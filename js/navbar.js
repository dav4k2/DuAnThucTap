document.addEventListener("DOMContentLoaded", function() {
    fetch("navbar.html")
        .then(response => response.text())
        .then(data => {
            const placeholder = document.getElementById("navbar-placeholder");
            if (placeholder) {
                placeholder.innerHTML = data;
                highlightCurrentPage();
                const adminName = localStorage.getItem('admin-name');
                if(adminName) {
                    setTimeout(() => {
                        const nameEl = document.getElementById('name-display');
                        if(nameEl) nameEl.innerText = adminName;
                    }, 0);
                }
            }
        })
        .catch(err => console.error("Lỗi tải navbar:", err));
});

// active tab
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

// đăng xuất
function toggleLogoutModal() {
    const modal = document.getElementById('logoutModal');
    modal.classList.toggle('active');
}

async function confirmLogout() {
    const btn = document.querySelector('#logoutModal .btn-danger');
    if(btn) {
        btn.disabled = true;
    }

    try {
        if (typeof firebase !== 'undefined') {
             await firebase.auth().signOut();
        }

        localStorage.removeItem('admin-name');
        localStorage.removeItem('admin-info');

        window.location.href = 'login.html'; 

    } catch (error) {
        console.error("Lỗi đăng xuất:", error);
        window.location.href = 'login.html';
    }
}

window.addEventListener('click', function(e) {
    const modal = document.getElementById('logoutModal');
    if (e.target == modal) {
        modal.classList.remove('active');
    }
});

function preventBack(){window.history.forward();}
setTimeout("preventBack()", 0);
window.onunload=function(){null};