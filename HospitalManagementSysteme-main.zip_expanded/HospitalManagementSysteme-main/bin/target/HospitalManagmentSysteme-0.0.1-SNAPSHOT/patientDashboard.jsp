<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Patient Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2a9d8f;
            --secondary-color: #264653;
            --gradient-bg: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            --glass-bg: rgba(255, 255, 255, 0.95);
        }

        body {
            background: var(--gradient-bg);
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
        }

        .sidebar {
            background: linear-gradient(135deg, var(--primary-color), #21867a);
            min-height: 100vh;
            color: white;
            padding: 2rem;
            box-shadow: 5px 0 25px rgba(0,0,0,0.1);
        }

        .main-content {
            padding: 2.5rem;
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
        }

        .profile-header {
            background: linear-gradient(135deg, var(--primary-color), #2a9d8f);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 25px rgba(42,157,143,0.2);
        }

        .info-card {
            background: var(--glass-bg);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            border: 1px solid rgba(0,0,0,0.1);
        }

        .lab-table {
            background: var(--glass-bg);
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .lab-item {
            background: white;
            border-left: 4px solid;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border-radius: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .lab-item:hover {
            transform: translateX(10px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .status-badge {
            padding: 0.6rem 1.2rem;
            border-radius: 25px;
            font-weight: 500;
            min-width: 120px;
            text-align: center;
        }

        .normal { border-color: #28a745; background: #e8f5e9; }
        .abnormal { border-color: #ffc107; background: #fff3e0; }
        .critical { border-color: #dc3545; background: #ffebee; }

        .logout-btn {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            padding: 1rem 2rem;
            border-radius: 12px;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 5px 20px rgba(239,68,68,0.2);
        }

        @media (max-width: 768px) {
            .sidebar {
                min-height: auto;
                padding: 1.5rem;
            }
            
            .main-content {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-lg-3 sidebar">
            <div class="d-flex flex-column align-items-center text-center">
                <div class="mb-4">
                    <i class="fas fa-user-circle fa-3x mb-3"></i>
                    <h3 class="mb-2">Patient Portal</h3>
                    <p class="mb-1">${patient.name}</p>
                    <small class="text-white-50">${patient.username}</small>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-lg-9 main-content">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div>
                        <h2>Medical Dashboard</h2>
                        <p class="mb-0">Date of Birth: ${patient.dob}</p>
                    </div>
                    <button class="btn btn-light" onclick="toggleEditForm()">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                </div>
            </div>

            <!-- Personal Info -->
            <div class="info-card">
                <h5 class="mb-4"><i class="fas fa-info-circle me-2"></i>Personal Information</h5>
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="detail-item">
                            <label class="text-muted">Address</label>
                            <p class="mb-0">${patient.address}</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="detail-item">
                            <label class="text-muted">Phone Number</label>
                            <p class="mb-0">${patient.phone}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Lab Results -->
            <div class="lab-table">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5><i class="fas fa-flask me-2"></i>Lab Results</h5>
                    <button class="btn btn-primary" onclick="toggleAllResults()">
                        <i class="fas fa-expand"></i> Toggle All
                    </button>
                </div>

                <c:choose>
                    <c:when test="${empty patient.labResults}">
                        <div class="alert alert-info">No lab results available</div>
                    </c:when>
                    <c:otherwise>
                        <div class="lab-results">
                            <c:forEach items="${patient.labResults}" var="lab">
                                <div class="lab-item ${lab.result.toLowerCase()}">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6>${lab.testName}</h6>
                                            <small class="text-muted">${lab.date}</small>
                                        </div>
                                        <span class="status-badge ${lab.result.toLowerCase()}">
                                            <i class="fas ${lab.result == 'Normal' ? 'fa-check-circle' : 
                                              lab.result == 'Abnormal' ? 'fa-exclamation-triangle' : 'fa-skull'} me-2"></i>
                                            ${lab.result}
                                        </span>
                                    </div>
                                    <div class="collapse">
                                        <div class="mt-3">
                                            <p class="mb-1">${lab.doctorComments}</p>
                                            <small class="text-muted">Test ID: ${lab.testId}</small>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Logout Button -->
<a href="LogoutServlet" class="btn logout-btn">
    <i class="fas fa-sign-out-alt"></i> Logout
</a>

<!-- Edit Profile Modal (existing code) -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Lab Results Toggle
    let allExpanded = false;
    function toggleAllResults() {
        const collapses = document.querySelectorAll('.collapse');
        collapses.forEach(collapse => {
            new bootstrap.Collapse(collapse, { toggle: true });
        });
        allExpanded = !allExpanded;
        event.target.innerHTML = allExpanded ? 
            '<i class="fas fa-compress"></i> Collapse All' : 
            '<i class="fas fa-expand"></i> Expand All';
    }

    // Smooth scroll to expanded lab result
    document.querySelectorAll('.lab-item').forEach(item => {
        item.addEventListener('click', () => {
            item.querySelector('.collapse').scrollIntoView({ 
                behavior: 'smooth', 
                block: 'center' 
            });
        });
    });

    // Dynamic Header Shadow
    window.addEventListener('scroll', () => {
        const header = document.querySelector('.profile-header');
        header.style.boxShadow = window.scrollY > 50 ? 
            '0 5px 15px rgba(0,0,0,0.1)' : 
            '0 10px 25px rgba(42,157,143,0.2)';
    });
</script>
</body>
</html>