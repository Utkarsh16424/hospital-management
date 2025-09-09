package com.hms.servelets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hms.util.DBUtil;

@WebServlet("/DoctorDashboard")
public class DoctorDashboard extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String doctorEmail = (String) session.getAttribute("email");
        
        if (doctorEmail == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            // Get doctor details
            Map<String, String> doctor = new HashMap<>();
            String doctorSql = "SELECT doctor, specialization, contact FROM doctors WHERE email = ?";
            try (PreparedStatement doctorStmt = conn.prepareStatement(doctorSql)) {
                doctorStmt.setString(1, doctorEmail);
                ResultSet doctorRs = doctorStmt.executeQuery();
                
                if (doctorRs.next()) {
                    doctor.put("name", doctorRs.getString("doctor"));
                    doctor.put("specialization", doctorRs.getString("specialization"));
                    doctor.put("contact", doctorRs.getString("contact"));
                    request.setAttribute("doctor", doctor);
                }
            }
            

            // Get patients list
            List<Map<String, String>> patients = new ArrayList<>();
            String patientSql = "SELECT username, name, dob, address, phone FROM patients";
            try (PreparedStatement patientStmt = conn.prepareStatement(patientSql)) {
                ResultSet patientRs = patientStmt.executeQuery();
                request.setAttribute("totalPatients", patients.size()); // Add this line
                request.setAttribute("patients", patients);
                
                while (patientRs.next()) {
                    Map<String, String> patient = new HashMap<>();
                    patient.put("username", patientRs.getString("username"));
                    patient.put("name", patientRs.getString("name"));
                    patient.put("dob", patientRs.getString("dob"));
                    patient.put("address", patientRs.getString("address"));
                    patient.put("phone", patientRs.getString("phone"));
                    patients.add(patient);
                }

                request.setAttribute("patients", patients);
            }

            // Get upcoming appointments count
            String appointmentSql = "SELECT COUNT(*) as count FROM appointments WHERE doctor = ? AND appointment_date >= CURDATE()";
            try (PreparedStatement appointmentStmt = conn.prepareStatement(appointmentSql)) {
                appointmentStmt.setString(1, doctorEmail);
                ResultSet appointmentRs = appointmentStmt.executeQuery();
                if (appointmentRs.next()) {
                    request.setAttribute("upcomingAppointments", appointmentRs.getInt("count"));
                }
            }

            request.getRequestDispatcher("doctorDashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}