package com.hms.servelets;

import java.io.IOException;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hms.dao.PatientDAO;
import com.hms.model.LabResult;
import com.hms.model.Patient;

/**
 * Servlet implementation class AddLabResultServlet
 */
@WebServlet("/AddLabResultServlet")
public class AddLabResultServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddLabResultServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("id");
        request.setAttribute("patientUsername", username);
        request.getRequestDispatcher("addLabResult.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String patientUsername = request.getParameter("patientUsername");
        String testName = request.getParameter("testName");
        String date = request.getParameter("date");
        String result = request.getParameter("result");
        String comments = request.getParameter("comments");
        
        String patientsPath = getServletContext().getRealPath("/WEB-INF/data/patients.json");
        
        try {
            List<Patient> patients = PatientDAO.readPatients(patientsPath);
            
            patients.stream()
                .filter(p -> p.getUsername().equals(patientUsername))
                .findFirst()
                .ifPresent(patient -> {
                    LabResult labResult = new LabResult(
                        UUID.randomUUID().toString(),
                        testName,
                        date,
                        result,
                        comments
                    );
                    patient.getLabResults().addAll((Collection<? extends Patient>) labResult);
                });
            
            PatientDAO.writePatients(patientsPath, patients);
            response.sendRedirect("DoctorDashboard?id=" + patientUsername + "&success=Lab+result+added");
            
        } catch (IOException e) {
            response.sendRedirect("DoctorDashboard?error=Error+adding+lab+result");
        }
    }

}
