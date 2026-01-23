document.addEventListener("DOMContentLoaded", function() {
    fetch("navbar.html")
        .then(response => response.text())
        .then(data => {
            const placeholder = document.getElementById("navbar_placeholder");
            if (placeholder) {
                placeholder.innerHTML = data;
                highlightCurrentPage();
                const adminName = localStorage.getItem('admin_name');
                if(adminName) {
                    setTimeout(() => {
                        const nameEl = document.getElementById('name_display');
                        if(nameEl) nameEl.innerText = adminName;
                    }, 0);
                }
            }
        })
        .catch(err => console.error("Lỗi tải navbar:", err));
});

function highlightCurrentPage() {
    const path = window.location.pathname;
    const page = path.split("/").pop(); 
    const targetPage = page || "index.html"; 

    const activeLink = document.querySelector(`nav a[data-page="${targetPage}"]`);
    
    if (activeLink) {
        const li = activeLink.querySelector('li');
        if(li) li.classList.add('active');
    }
}

function toggleLogoutModal() {
    const modal = document.getElementById('logout_modal');
    modal.classList.toggle('active');
}

async function confirmLogout() {
    const btn = document.querySelector('#logout_modal .btn-danger');
    if(btn) {
        btn.disabled = true;
    }

    try {
        if (typeof firebase !== 'undefined') {
             await firebase.auth().signOut();
        }
        
        localStorage.removeItem('admin_name');
        localStorage.removeItem('admin_info');

        window.location.href = 'login.html'; 

    } catch (error) {
        console.error("Lỗi đăng xuất:", error);
        window.location.href = 'login.html';
    }
}

window.addEventListener('click', function(e) {
    const modal = document.getElementById('logout_modal');
    if (e.target == modal) {
        modal.classList.remove('active');
    }
});

function preventBack(){window.history.forward();}
setTimeout("preventBack()", 0);
window.onunload=function(){null};