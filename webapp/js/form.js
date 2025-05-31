// form.js
document.addEventListener('DOMContentLoaded', function() {
    // Password toggle for Login page (password field)
    const togglePasswordLogin = document.getElementById('togglePassword');
    const passwordLogin = document.getElementById('password');

    if (togglePasswordLogin && passwordLogin) {
        togglePasswordLogin.addEventListener('click', function () {
            const type = passwordLogin.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordLogin.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
    } else {
        console.log("Login page password toggle elements not found (expected on Registration page).");
    }

    // Password toggle for Registration page (password field)
    const togglePasswordReg = document.getElementById('togglePassword');
    const passwordReg = document.getElementById('password');

    if (togglePasswordReg && passwordReg) {
        togglePasswordReg.addEventListener('click', function () {
            const type = passwordReg.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordReg.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
    } else {
        console.log("Registration page password toggle elements not found (expected on Login page).");
    }

    // Password toggle for Registration page (confirmPassword field)
    const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
    const confirmPassword = document.getElementById('confirmPassword');

    if (toggleConfirmPassword && confirmPassword) {
        toggleConfirmPassword.addEventListener('click', function () {
            const type = confirmPassword.getAttribute('type') === 'password' ? 'text' : 'password';
            confirmPassword.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
    } else {
        console.log("Confirm password toggle elements not found (expected on Login page).");
    }
});