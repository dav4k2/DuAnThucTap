let currentEditId = null; 
let currentDeleteId = null;
let allUsersData = []; 
let currentSortMode = 'default'; 
let currentPage = 1;
const rowsPerPage = 10;
let currentFilteredData = [];
let editModal, successModal, deleteModal;

document.addEventListener("DOMContentLoaded", async () => {
    editModal = document.getElementById('editModal');
    successModal = document.getElementById('successModal');
    deleteModal = document.getElementById('deleteModal');

    await loadUsers();
});

async function loadUsers() {
    const tableBody = document.getElementById("table_users");
    try {
        const response = await fetch("/api/get_all_users");
        const data = await response.json();
        allUsersData = data.users || data || [];
        allUsersData = allUsersData.map((user, idx) => ({ ...user, originalIndex: idx }));
        handleSearchAndSort();
    } catch (error) {
        console.error("Lỗi tải user:", error);
        tableBody.innerHTML = "<tr><td colspan='7' style='text-align:center; color:red;'>Lỗi kết nối Server!</td></tr>";
    }
}

// sắp xếp 
function handleSearchAndSort() {
    const keyword = document.getElementById('search_user').value.toLowerCase();
    
    let filtered = allUsersData.filter(user => {
        const name = (user.name || user.display_name || '').toLowerCase();
        const email = (user.email || '').toLowerCase();
        return name.includes(keyword) || email.includes(keyword);
    });

    if (currentSortMode === 'az') {
        filtered.sort((a, b) => (a.name || '').localeCompare(b.name || ''));
    } else if (currentSortMode === 'za') {
        filtered.sort((a, b) => (b.name || '').localeCompare(a.name || ''));
    } else {
        filtered.sort((a, b) => a.originalIndex - b.originalIndex);
    }
    currentFilteredData = filtered;
    currentPage = 1;
    updateTableDisplay();
}

function updateTableDisplay() {
    const totalItems = currentFilteredData.length;
    const totalPages = Math.ceil(totalItems / rowsPerPage);

    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;

    const start = (currentPage - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    const paginatedItems = currentFilteredData.slice(start, end);

    renderTable(paginatedItems, start);
    renderPagination(totalItems, totalPages);
}

function renderTable(users, startIndex) {
    const tableBody = document.getElementById("table_users");
    tableBody.innerHTML = "";

    if (users.length === 0) {
        tableBody.innerHTML = "<tr><td colspan='7' style='text-align:center'>Không tìm thấy kết quả.</td></tr>";
        return;
    }

    users.forEach((user, index) => {
        const row = document.createElement("tr");
        const avatarUrl = user.photo || user.avatar_url || 'images/avatar.png';
        const userName = user.name || user.display_name || 'Chưa đặt tên';
        const userId = user.uid || user.id;

        let statusHtml = `<span class="txt_green">Hoạt động</span>`;
        if (user.disabled) statusHtml = `<span style="color:red">Đã khóa</span>`;

        row.innerHTML = `
            <td>${startIndex + index + 1}</td>
            <td class="user_info_cell">
                <img src="${avatarUrl}" style="border-radius: 50%; width: 30px; height: 30px; object-fit: cover;"> 
                <strong>${userName}</strong>
            </td>
            <td>${user.email}</td>
            <td><small>${userId}</small></td>
            <td>${statusHtml}</td>
            <td class="actions_cell">
                <div class="action_btns">
                    <a href="javascript:void(0)" onclick="openEditModal('${userId}')"><img src="images/edit.png" title="Sửa"></a>
                    <a href="javascript:void(0)" onclick="openDeleteModal('${userId}')"><img src="images/delete.png" title="Xóa"></a>
                </div>
            </td>
        `;
        tableBody.appendChild(row);
    });
}

function renderPagination(totalItems, totalPages) {
    const paginationBlock = document.getElementById('pagination_block');
    const controls = document.getElementById('pagination_controls');
    const startVal = totalItems === 0 ? 0 : (currentPage - 1) * rowsPerPage + 1;
    const endVal = Math.min(currentPage * rowsPerPage, totalItems);
    document.getElementById('current_start').innerText = startVal;
    document.getElementById('current_end').innerText = endVal;
    document.getElementById('total_items').innerText = totalItems;

    if (totalItems === 0) {
        paginationBlock.style.display = 'none';
        return;
    }
    paginationBlock.style.display = 'flex';
    controls.innerHTML = '';

    const createBtn = (text, page, isActive = false, isDisabled = false) => {
        const btn = document.createElement('button');
        btn.className = `page_btn ${isActive ? 'active' : ''} ${isNaN(text) ? 'nav_btn' : ''}`;
        btn.innerText = text;
        if (isDisabled) btn.disabled = true;
        else btn.onclick = () => { currentPage = page; updateTableDisplay(); };
        return btn;
    };

    controls.appendChild(createBtn('Trước', currentPage - 1, false, currentPage === 1));

    if (totalPages <= 7) {
        for (let i = 1; i <= totalPages; i++) controls.appendChild(createBtn(i, i, i === currentPage));
    } else {
        if (currentPage <= 4) {
            for (let i = 1; i <= 5; i++) controls.appendChild(createBtn(i, i, i === currentPage));
            controls.appendChild(createBtn('...', null, false, true));
            controls.appendChild(createBtn(totalPages, totalPages, totalPages === currentPage));
        } else if (currentPage >= totalPages - 3) {
            controls.appendChild(createBtn(1, 1, 1 === currentPage));
            controls.appendChild(createBtn('...', null, false, true));
            for (let i = totalPages - 4; i <= totalPages; i++) controls.appendChild(createBtn(i, i, i === currentPage));
        } else {
            controls.appendChild(createBtn(1, 1, 1 === currentPage));
            controls.appendChild(createBtn('...', null, false, true));
            controls.appendChild(createBtn(currentPage - 1, currentPage - 1, false));
            controls.appendChild(createBtn(currentPage, currentPage, true));
            controls.appendChild(createBtn(currentPage + 1, currentPage + 1, false));
            controls.appendChild(createBtn('...', null, false, true));
            controls.appendChild(createBtn(totalPages, totalPages, totalPages === currentPage));
        }
    }
    controls.appendChild(createBtn('Sau', currentPage + 1, false, currentPage === totalPages));
}

// dropdown 
function toggleSortDropdown() {
    const el = document.getElementById('sort_dropdown_content');
    const icon = document.getElementById('sort_dropdown_icon');
    if(el) el.classList.toggle('show');
    if(icon) icon.classList.toggle('rotate');
}

function selectSortMode(mode, text) {
    currentSortMode = mode;
    document.getElementById('sort_display_text').innerText = text;
    toggleSortDropdown(); 
    handleSearchAndSort();
}

function toggleStatusDropdown() { closeDropdown('duration'); toggleDropdownUI('status'); }
function selectStatus(value, text) {
    document.getElementById('edit_status_value').value = value;
    document.getElementById('status_display_text').innerText = text;
    toggleStatusDropdown();
    toggleBanState();
}
function toggleDurationDropdown() {
    if(document.getElementById('duration_summary_box').classList.contains('disabled')) return;
    closeDropdown('status');
    toggleDropdownUI('duration');
}
function selectDuration(value, text) {
    document.getElementById('edit_ban_duration').value = value;
    document.getElementById('duration_display_text').innerText = text;
    toggleDurationDropdown();
}
function toggleDropdownUI(type) {
    const el = document.getElementById(`${type}_dropdown_content`);
    const icon = document.getElementById(`${type}_dropdown_icon`);
    if(el) el.classList.toggle('show');
    if(icon) icon.classList.toggle('rotate');
}
function closeDropdown(type) {
    const el = document.getElementById(`${type}_dropdown_content`);
    const icon = document.getElementById(`${type}_dropdown_icon`);
    if(el) el.classList.remove('show');
    if(icon) icon.classList.remove('rotate');
}

function closeAllModals() {
    if(editModal) editModal.classList.remove('active');
    if(successModal) successModal.classList.remove('active');
    if(deleteModal) deleteModal.classList.remove('active');
    closeDropdown('status'); closeDropdown('duration'); closeDropdown('sort');
}

function openEditModal(uid) {
    const user = allUsersData.find(u => (u.uid || u.id) === uid);
    if (!user) return alert("Không tìm thấy thông tin!");
    currentEditId = uid;
    
    document.getElementById('edit_name_label').innerText = user.name || 'No Name';
    document.getElementById('edit_uid').innerText = 'ID: ' + uid;
    document.getElementById('edit_name').value = user.name || '';
    document.getElementById('edit_email').value = user.email || '';
    
    const avatarImg = document.getElementById('edit_avatar');
    if(avatarImg) avatarImg.src = user.photo || 'images/avatar.png';

    const isBanned = user.disabled ? "true" : "false";
    document.getElementById('edit_status_value').value = isBanned;
    document.getElementById('status_display_text').innerText = isBanned === "true" ? "Khóa tài khoản" : "Hoạt động";
    document.getElementById('edit_ban_duration').value = 'permanent';
    document.getElementById('duration_display_text').innerText = 'Vĩnh viễn';
    
    toggleBanState();
    editModal.classList.add('active');
}

function toggleBanState() {
    const statusValue = document.getElementById('edit_status_value').value;
    const durationBox = document.getElementById('duration_summary_box');

    if (statusValue === "true") {
        durationBox.classList.remove('disabled');
    } else {
        durationBox.classList.add('disabled');
        document.getElementById('duration_display_text').innerText = 'Vĩnh viễn';
        document.getElementById('edit_ban_duration').value = 'permanent';
    }
}

async function handleSave() {
    if(!currentEditId) return;

    const nameInput = document.getElementById('edit_name');
    const emailInput = document.getElementById('edit_email');
    const statusInput = document.getElementById('edit_status_value');
    const durationInput = document.getElementById('edit_ban_duration');
    const newData = {
        display_name: nameInput.value,
        email: emailInput.value,
        disabled: statusInput.value === "true",
        ban_duration: durationInput.value
    };

    const btn = document.querySelector('.btn_save_changes'); 
    const originalText = btn.innerText;
    btn.disabled = true;

    try {
        const res = await fetch(`/api/update_user/${currentEditId}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(newData)
        });
        
        if (res.ok) {
            closeAllModals();
            if(successModal) {
                successModal.classList.add('active');
                const okBtn = successModal.querySelector('button');
                if(okBtn) okBtn.onclick = () => successModal.classList.remove('active');
            } else {
                alert("Cập nhật thành công!");
            }
            await loadUsers(); 

        } else { 
            alert("Lỗi khi cập nhật!"); 
        }
    } catch (err) { 
        console.error(err);
        alert("Lỗi kết nối server"); 
    } finally {
        btn.innerText = originalText;
        btn.disabled = false;
    }
}

function openDeleteModal(uid) { currentDeleteId = uid; deleteModal.classList.add('active'); }

async function confirmDeleteAction() {
    if (!currentDeleteId) return;
    const deleteBtn = document.querySelector('#deleteModal .btn_danger');
    try {
        const res = await fetch(`/api/delete_user/${currentDeleteId}`, { method: 'DELETE' });
        if (res.ok) {
            closeAllModals();
            alert("Đã xóa thành công!");
            location.reload(); 
        } else { alert(`Xóa thất bại!`); }
    } catch(e) { alert("Lỗi kết nối Server."); } 
    finally { deleteBtn.innerText = "Xóa vĩnh viễn"; }
}

function exportToExcel() {
    if (!allUsersData.length) return alert("Không có dữ liệu!");
    const dataForExcel = allUsersData.map((user, index) => ({
        "STT": index + 1, "ID": user.uid || user.id, 
        "Tên hiển thị": user.name || user.display_name,
        "Email": user.email, "Trạng thái": user.disabled ? "Đã khóa" : "Hoạt động"
    }));
    const worksheet = XLSX.utils.json_to_sheet(dataForExcel);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, "Danh sách User");
    XLSX.writeFile(workbook, `DS_Nguoi_Dung_${new Date().toISOString().slice(0,10)}.xlsx`);
}

window.onclick = function(event) {
    if (event.target == editModal || event.target == successModal || event.target == deleteModal) closeAllModals();
    if (!event.target.closest('#sort_manager')) {
        const el = document.getElementById('sort_dropdown_content');
        if(el && el.classList.contains('show')) toggleSortDropdown();
    }
    if (!event.target.closest('#status_manager') && !event.target.closest('#duration_manager')) {
        closeDropdown('status'); closeDropdown('duration');
    }
}