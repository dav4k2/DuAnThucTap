document.addEventListener("DOMContentLoaded", () => {
    firebase.auth().onAuthStateChanged((user) => {
        if (user) {
            displayAdminInfo(user);
        } else {
            window.location.href = 'login.html';
        }
    });

    setupPasswordToggle('new_password', 'toggle_new_pwd');
    setupPasswordToggle('confirm_password', 'toggle_confirm_pwd');

    const inputs = [document.getElementById('new_password'), document.getElementById('confirm_password')];
    inputs.forEach(input => {
        if (input) {
            input.addEventListener("keypress", function(event) {
                if (event.key === "Enter") {
                    event.preventDefault(); 
                    handleChangePassword();
                }
            });
        }
    });
});

function setupPasswordToggle(inputId, toggleId) {
    const toggleBtn = document.getElementById(toggleId);
    const passwordInput = document.getElementById(inputId);

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
}

function displayAdminInfo(user) {
    const nameEl = document.getElementById('admin_name');
    const emailEl = document.getElementById('admin_email');
    if (emailEl) emailEl.innerText = user.email;
    const storedName = localStorage.getItem('admin_name'); 
    if (nameEl) nameEl.innerText = storedName || user.email.split('@')[0];
}

function openPasswordModal() {
    const modal = document.getElementById('password_modal');
    if(!modal) return;
    
    document.getElementById('new_password').value = '';
    document.getElementById('confirm_password').value = '';
    const errEl = document.getElementById('pwd_error');
    if(errEl) {
        errEl.style.display = 'none';
        errEl.innerText = '';
    }
    
    resetInputState('new_password', 'toggle_new_pwd');
    resetInputState('confirm_password', 'toggle_confirm_pwd');

    modal.classList.add('active');
}

function resetInputState(inputId, toggleId) {
    const input = document.getElementById(inputId);
    const icon = document.getElementById(toggleId);
    if(input) input.setAttribute('type', 'password');
    if(icon) icon.src = 'images/show.png';
}

function closePasswordModal() {
    const modal = document.getElementById('password_modal');
    if(modal) modal.classList.remove('active');
}

async function handleChangePassword() {
    const newPass = document.getElementById('new_password').value;
    const confirmPass = document.getElementById('confirm_password').value;
    const errorMsg = document.getElementById('pwd_error');
    const btn = document.querySelector('#password_modal .btn_save');
    
    errorMsg.style.display = 'none';

    if (newPass.length < 6) {
        errorMsg.innerText = "Mật khẩu phải có ít nhất 6 ký tự.";
        errorMsg.style.display = 'block';
        return;
    }
    if (newPass !== confirmPass) {
        errorMsg.innerText = "Mật khẩu xác nhận không khớp.";
        errorMsg.style.display = 'block';
        return;
    }

    const originalText = btn.innerText;
    btn.disabled = true;
    btn.innerText = "Đang xử lý...";

    try {
        const user = firebase.auth().currentUser;
        if(user) {
            await user.updatePassword(newPass);
            alert("Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
            closePasswordModal();
            await firebase.auth().signOut();
            localStorage.removeItem('admin_name'); 
            window.location.href = 'login.html';
        } else {
            alert("Không tìm thấy thông tin người dùng.");
        }
    } catch (error) {
        console.error("Lỗi đổi pass:", error);
        errorMsg.style.display = 'block';
        
        if(error.code === 'auth/requires-recent-login') {
            errorMsg.innerText = "Phiên đăng nhập cũ. Vui lòng đăng xuất và đăng nhập lại.";
            setTimeout(async () => {
                 await firebase.auth().signOut();
                 window.location.href = 'login.html';
            }, 3000);
        } else {
            errorMsg.innerText = "Lỗi: " + error.message;
        }
    } finally {
        btn.disabled = false;
        btn.innerText = originalText;
    }
}

window.addEventListener('click', function(e) {
    const modal = document.getElementById('password_modal');
    if (e.target == modal) {
        closePasswordModal();
    }
});