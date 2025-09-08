<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Patient Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #4affe2, #6c757d);
            --success-gradient: linear-gradient(135deg, #28a745, #218838);
            --error-gradient: linear-gradient(135deg, #dc3545, #c82333);
            --card-bg: rgba(255, 255, 255, 0.95);
        }

        body {
            background: linear-gradient(45deg, #6a11cb, #2575fc, #4affe2);
            background-size: 600% 600%;
            animation: gradientBG 15s ease infinite;
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .registration-card {
            backdrop-filter: blur(20px);
            border-radius: 20px;
            box-shadow: 0 15px 50px rgba(0,0,0,0.1);
            
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
            overflow: visible;
            position: relative;
            z-index: 1;
        }

        .registration-card:hover {
         
            box-shadow: 0 20px 70px rgba(0,0,0,0.2);
        }

        .form-header {
            background: var(--primary-gradient);
            padding: 3rem 2.5rem;
            border-radius: 20px 20px 0 0;
            position: relative;
        }

        .form-header::before {
            content: '';
            position: absolute;
            top: -20px;
            left: -20px;
            right: -20px;
            bottom: -20px;
            background: var(--primary-gradient);
            border-radius: 30px;
            z-index: -1;
            filter: blur(20px);
        }

        .input-group-custom {
            position: relative;
            margin-bottom: 2rem;
        }

        .form-control {
            border: 0;
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.8);
            padding: 1.2rem 2rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background: white;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
         
        }

        .password-strength {
            height: 6px;
            background: #e9ecef;
            border-radius: 3px;
            margin-top: 0.5rem;
        }

        .strength-bar {
            height: 100%;
            background: linear-gradient(90deg, #dc3545, #ffc107, #28a745);
      
        }

        .btn-register {
            background: var(--primary-gradient);
            border: 0;
            border-radius: 25px;
            padding: 1.2rem 3rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-register:hover {
            background: linear-gradient(135deg, #2575fc, #4affe2);
        
            box-shadow: 0 5px 20px rgba(37, 117, 252, 0.3);
        }

        .btn-register::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transition: width 0.6s ease, height 0.6s ease;
        }

        .btn-register:active::after {
            width: 200%;
            height: 200%;
            transition: 0s;
        }

        .login-link a:hover {
            color: #4affe2;
            text-shadow: 0 0 10px rgba(74, 144, 226, 0.5);
        }

        /* New animated gradient divider */
        .divider {
            position: relative;
            margin: 3rem 0;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: linear-gradient(90deg, #6a11cb, #2575fc, #4affe2);
            background-size: 200% 100%;
            animation: gradientDivider 3s infinite;
        }

        @keyframes gradientDivider {
            0% { background-position: 0% 50%; }
            100% { background-position: 100% 50%; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="registration-card">
        <div class="form-header">
            <h2 class="mb-3"><i class="fas fa-heartbeat"></i> Patient Registration</h2>
            <p class="mb-0">Join our healthcare community</p>
        </div>
        
        <div class="form-body">
            <form action="RegisterServlet" method="post" id="registrationForm" novalidate>
                <div class="row g-4">
                    <!-- Username -->
                    <div class="col-md-6">
                        <div class="input-group-custom">
                            <input type="text" class="form-control" name="username" 
                                   placeholder="Username" required
                                   pattern="[A-Za-z0-9]{4,20}">
                            <i class="fas fa-user input-icon"></i>
                            <span class="validation-feedback"><i class="fas fa-check"></i></span>
                            <div class="invalid-feedback">4-20 characters (letters/numbers only)</div>
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="col-md-6">
                        <div class="input-group-custom">
                            <input type="password" class="form-control" name="password" 
                                   id="password" placeholder="Password" required
                                   pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$">
                            <i class="fas fa-lock input-icon password-toggle"></i>
                            <span class="validation-feedback"><i class="fas fa-check"></i></span>
                            <div class="password-strength">
                                <div class="strength-bar" id="strengthBar"></div>
                            </div>
                            <div class="invalid-feedback">Minimum 6 characters with 1 letter &amp; 1 number</div>
                        </div>
                    </div>

                    <!-- Full Name -->
                    <div class="col-12">
                        <div class="input-group-custom">
                            <input type="text" class="form-control" name="name" 
                                   placeholder="Full Name" required>
                            <i class="fas fa-id-card input-icon"></i>
                            <span class="validation-feedback"><i class="fas fa-check"></i></span>
                            <div class="invalid-feedback">Please enter your full name</div>
                        </div>
                    </div>

                    <!-- Date of Birth -->
                    <div class="col-md-6">
                        <div class="input-group-custom">
                            <input type="date" class="form-control" name="dob" 
                                   id="dob" required max="">
                            <i class="fas fa-calendar-day input-icon"></i>
                            <div class="invalid-feedback">Please select your date of birth</div>
                        </div>
                    </div>

                    <!-- Phone Number -->
                    <div class="col-md-6">
                        <div class="input-group-custom">
                            <input type="tel" class="form-control" name="phone" 
                                   placeholder="Phone Number" required
                                   pattern="[0-9]{10,15}">
                            <i class="fas fa-phone input-icon"></i>
                            <span class="validation-feedback"><i class="fas fa-check"></i></span>
                            <div class="invalid-feedback">10-15 digit phone number required</div>
                        </div>
                    </div>

                    <!-- Address -->
                    <div class="col-12">
                        <div class="input-group-custom">
                            <input type="text" class="form-control" name="address" 
                                   placeholder="Address" required>
                            <i class="fas fa-map-marker-alt input-icon"></i>
                            <span class="validation-feedback"><i class="fas fa-check"></i></span>
                            <div class="invalid-feedback">Please enter your address</div>
                        </div>
                    </div>

                    <!-- Terms Checkbox -->
                    <div class="col-12">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="terms" required>
                            <label class="form-check-label terms-text" for="terms">
                                I agree to the <a href="#" class="text-primary">Terms of Service</a> and 
                                <a href="#" class="text-primary">Privacy Policy</a>
                            </label>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="col-12">
                        <button type="submit" class="btn-register w-100">
                            <i class="fas fa-user-plus me-2"></i>Create Account
                        </button>
                    </div>
                </div>
            </form>

            <div class="login-link">
                Already have an account? <a href="login.jsp">Sign In Here</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Animated Card Entrance
    document.addEventListener('DOMContentLoaded', () => {
        const card = document.querySelector('.registration-card');
        card.style.opacity = '1';
    });

    // Password Strength Calculator
    const calculatePasswordStrength = (password) => {
        let strength = 0;
        if (password.length >= 8) strength += 25;
        if (/[A-Z]/.test(password)) strength += 25;
        if (/\d/.test(password)) strength += 25;
        if (/[^A-Za-z0-9]/.test(password)) strength += 25;
        return Math.min(strength, 100);
    };

    // Password Strength Indicator
    const passwordInput = document.getElementById('password');
    const strengthBar = document.getElementById('strengthBar');
    
    passwordInput.addEventListener('input', function() {
        const strength = calculatePasswordStrength(this.value);
        strengthBar.style.width = strength + '%';
        strengthBar.style.backgroundColor = 
            strength >= 75 ? '#28a745' :
            strength >= 50 ? '#ffc107' : '#dc3545';
    });

    // Toggle Password Visibility
    document.querySelector('.password-toggle').addEventListener('click', function() {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        this.classList.toggle('fa-lock-open');
    });

    // Real-time Validation
    document.querySelectorAll('.form-control').forEach(input => {
        input.addEventListener('input', () => {
            const isValid = input.checkValidity();
            input.parentElement.classList.toggle('valid', isValid);
            input.parentElement.classList.toggle('invalid', !isValid);
        });
    });

    // Date Validation (Max = Today)
    const dobInput = document.getElementById('dob');
    dobInput.max = new Date().toISOString().split('T')[0];

    // Form Submission Handler
    document.getElementById('registrationForm').addEventListener('submit', function(e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
            this.classList.add('was-validated');
            
            // Scroll to first invalid field
            const firstInvalid = this.querySelector(':invalid');
            firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
            firstInvalid.focus();
        }
    });

    // Phone Number Formatting
    document.querySelector('[name="phone"]').addEventListener('input', function(e) {
        this.value = this.value.replace(/\D/g, '').slice(0, 15);
    });

    // Terms Checkbox Animation
    document.getElementById('terms').addEventListener('change', function() {
        this.parentElement.classList.toggle('checked', this.checked);
    });
</script>
</body>
</html>