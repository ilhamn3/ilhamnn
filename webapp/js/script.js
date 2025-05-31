// Password toggle for Password field (used in both login and registration)
const togglePassword = document.getElementById('togglePassword');
if (togglePassword) {
    const password = document.getElementById('password');
    togglePassword.addEventListener('click', function () {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        this.classList.toggle('fa-eye');
        this.classList.toggle('fa-eye-slash');
    });
}

// Password toggle for Confirm Password field (used in registration)
const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
if (toggleConfirmPassword) {
    const confirmPassword = document.getElementById('confirmPassword');
    toggleConfirmPassword.addEventListener('click', function () {
        const type = confirmPassword.getAttribute('type') === 'password' ? 'text' : 'password';
        confirmPassword.setAttribute('type', type);
        this.classList.toggle('fa-eye');
        this.classList.toggle('fa-eye-slash');
    });
}

// Form submission alert for login form
const loginForm = document.getElementById('loginForm');
if (loginForm) {
    loginForm.addEventListener('submit', function(event) {
        event.preventDefault(); // Prevent form submission for demo purposes
        alert('Login form submitted! (This is a demo, no actual login occurs.)');
    });
}

// Form submission alert for registration form
const registerForm = document.getElementById('registerForm');
if (registerForm) {
    registerForm.addEventListener('submit', function(event) {
        event.preventDefault(); // Prevent form submission for demo purposes
        alert('Registration form submitted! (This is a demo, no actual registration occurs.)');
    });
}