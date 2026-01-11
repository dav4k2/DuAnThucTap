document.addEventListener("DOMContentLoaded", () => {
    firebase.auth().onAuthStateChanged(async (user) => {
        if (user) {
            updateUI(user.displayName, user.email, null);
            try {
                const res = await fetch(`/api/check-admin-access/${user.uid}`);
                const data = await res.json();

                if (data.is_admin) {
                    updateUI(data.name, data.email, data.avatar);
                }
            } catch (error) {
                console.error("Lỗi lấy thông tin admin", error);
            }
        } else {
            window.location.href = 'login.html';
        }
    });
});

// hiện thông tin admin
function updateUI(name, email, avatarUrl) {
    const nameEl = document.getElementById('admin_name');
    const emailEl = document.getElementById('admin_email');

    if (name && nameEl) nameEl.innerText = name;
    if (email && emailEl) emailEl.innerText = email;
    
    if (avatarUrl && avatarEl) {
        avatarEl.style.backgroundImage = `url('${avatarUrl}')`;
    }
}

// modal đổi mk
const passwordModal = document.getElementById('passwordModal');

function openPasswordModal() {
    passwordModal.classList.add('active');
    document.getElementById('pwd_error').style.display = 'none';
    document.getElementById('new_password').value = '';
    document.getElementById('confirm_password').value = '';
}

function closePasswordModal() {
    passwordModal.classList.remove('active');
}

window.onclick = function(event) {
    if (event.target == passwordModal) {
        closePasswordModal();
    }
}

// đổi mật khẩu
async function handleChangePassword() {
    const newPass = document.getElementById('new_password').value;
    const confirmPass = document.getElementById('confirm_password').value;
    const errorMsg = document.getElementById('pwd_error');
    const btn = document.querySelector('#passwordModal .btn_save');

    // ràng buộc
    if (newPass.length < 6) {
        showError(errorMsg, "Mật khẩu phải có ít nhất 6 ký tự!");
        return;
    }
    if (newPass !== confirmPass) {
        showError(errorMsg, "Mật khẩu xác nhận không khớp!");
        return;
    }

    errorMsg.style.display = "none";
    btn.disabled = true;

    const user = firebase.auth().currentUser;
    if (user) {
        try {
            await user.updatePassword(newPass);
            alert("Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
            await firebase.auth().signOut();
            window.location.href = 'login.html';
        } catch (error) {
            console.error(error);
            if (error.code === 'auth/requires-recent-login') {
                alert("Để bảo mật, bạn cần đăng xuất và đăng nhập lại trước khi đổi mật khẩu.");
                await firebase.auth().signOut();
                window.location.href = 'login.html';
            } else {
                showError(errorMsg, "Lỗi: " + error.message);
            }
        } finally {
            btn.innerText = "Cập nhật";
            btn.disabled = false;
        }
    }
}

function showError(el, msg) {
    el.innerText = msg;
    el.style.display = "block";
}