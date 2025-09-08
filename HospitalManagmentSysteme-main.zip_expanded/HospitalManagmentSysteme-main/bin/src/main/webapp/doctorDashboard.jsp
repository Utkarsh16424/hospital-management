<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #6c5ce7 0%, #a8a4e6 100%);
            --secondary-color: #4b4453;
            --accent-color: #00f511;
        }

        body {
            background: linear-gradient(150deg, #f8f9fa 0%, #e9ecef 100%);
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
        }

        .dashboard-header {
            background: var(--primary-gradient);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(108,92,231,0.2);
            margin-bottom: 2rem;
        }

        .patient-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 25px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }

        .table-header {
            background: var(--primary-gradient);
            color: white;
            font-weight: 500;
        }

        .table-hover tbody tr {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .table-hover tbody tr:hover {
            transform: translateX(10px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .action-btn {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            border: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-edit {
            background: linear-gradient(45deg, #ffc107, #ffd54f);
            color: #2d2d39;
        }

        .btn-delete {
            background: linear-gradient(45deg, #ff4757, #ff6b6b);
            color: white;
        }

        .btn-lab {
            background: linear-gradient(45deg, #2ed573, #48dbb4);
            color: white;
        }

        .search-container {
            max-width: 400px;
            margin-left: auto;
            position: relative;
        }

        .logout-footer {
            position: fixed;
            bottom: 0;
            right: 0;
            padding: 1rem 2rem;
            background: rgba(255,255,255,0.9);
            border-radius: 15px 0 0 15px;
            box-shadow: -5px 0 15px rgba(0,0,0,0.05);
        }

        .patient-count-badge {
            background: var(--accent-color);
            padding: 0.5rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .dashboard-header {
                padding: 1.5rem;
            }
            
            .action-btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<div class="container-fluid py-4">
    <div class="row">
        <div class="col-12">
            <!-- Header Section -->
            <div class="dashboard-header d-flex justify-content-between align-items-center">
                <div>
                    <h3><i class="fas fa-user-md"></i> Doctor Dashboard</h3>
                    <div class="patient-count-badge mt-2">
                        Total Patients: ${patients.size()}
                    </div>
                </div>
                <div class="search-container">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Search patients...">
                        <button class="btn btn-primary">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Patients Table -->
            <div class="patient-table">
                <table class="table table-hover">
                    <thead class="table-header">
                        <tr>
                            <th>Patient Name</th>
                            <th>Date of Birth</th>
                            <th>Lab Results</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${patients}" var="patient">
                            <tr>
                                <td>${patient.name}</td>
                                <td>${patient.dob}</td>
                                <td>
                                    <a href="DisplayLabResultsServlet?id=${patient.username}" 
                                       class="text-decoration-none text-primary">
                                        <i class="fas fa-file-medical"></i> View Results
                                    </a>
                                </td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <a href="EditPatientServlet?id=${patient.username}" 
                                           class="action-btn btn-edit">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <a href="DeletePatientServlet?id=${patient.username}" 
                                           class="action-btn btn-delete"
                                           onclick="return confirm('Are you sure you want to delete ${patient.name}?')">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                        <a href="AddLabResultServlet?id=${patient.username}" 
                                           class="action-btn btn-lab">
                                            <i class="fas fa-plus"></i> New Lab
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Logout Footer -->
            <div class="logout-footer">
                <a href="LogoutServlet" class="btn btn-danger">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Enhanced Search Functionality
    const searchInput = document.querySelector('input[type="text"]');
    let searchTimeout;

    searchInput.addEventListener('input', function(e) {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            const searchTerm = e.target.value.toLowerCase();
            document.querySelectorAll('tbody tr').forEach(row => {
                const name = row.children[0].textContent.toLowerCase();
                const dob = row.children[1].textContent.toLowerCase();
                const shouldShow = name.includes(searchTerm) || dob.includes(searchTerm);
                row.style.display = shouldShow ? 'table-row' : 'none';
                
                if(shouldShow) {
                    row.style.animation = 'fadeIn 0.3s ease';
                }
            });
        }, 300);
    });

    // Row Hover Effect
    document.querySelectorAll('tbody tr').forEach(row => {
        row.addEventListener('mouseenter', () => {
            row.style.transform = 'scale(1.02)';
        });
        
        row.addEventListener('mouseleave', () => {
            row.style.transform = 'scale(1)';
        });
    });
</script>
</body>
</html>