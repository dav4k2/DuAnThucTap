// xử lý đăng nhập
async function handleLogin() {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const btn = document.querySelector('.login_btn');

    if (!email || !password) {
        alert("Vui lòng nhập đầy đủ Email và Mật khẩu!");
        return;
    }

    const originalText = btn.innerText;
    btn.disabled = true;

    try {
        await firebase.auth().signInWithEmailAndPassword(email, password);
        window.location.href = "dashboard.html";
    } catch (error) {
        console.error("Lỗi:", error);
        let msg = "Đăng nhập thất bại.";
        if (error.code === 'auth/user-not-found') msg = "Tài khoản hoặc mật khẩu sai.";
        if (error.code === 'auth/wrong-password') msg = "Tài khoản hoặc mật khẩu sai.";
        alert(msg);
        btn.innerText = originalText;
        btn.disabled = false;
    } 
}

document.addEventListener("DOMContentLoaded", function() {
    const toggleBtn = document.getElementById('showPassword');
    const passwordInput = document.getElementById('password');

    if (toggleBtn && passwordInput) {
        toggleBtn.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            if (type === 'text') {
                this.src = 'images/hide.png'; 
            } else {
                this.src = 'images/show.png'; 
            }
        });
    }

    const inputs = [document.getElementById('email'), document.getElementById('password')];
    inputs.forEach(input => {
        if (input) {
            input.addEventListener("keypress", function(event) {
                if (event.key === "Enter") {
                    event.preventDefault(); 
                    handleLogin(); 
                }
            });
        }
    });
});