let currentEditId = null; 
let currentDeleteId = null;
let allRecipesData = []; 
let currentSortMode = 'default';
let currentPage = 1;
const rowsPerPage = 5;
let currentFilteredData = [];

const AVAILABLE_TAGS = [
    "Bữa sáng", "Bữa trưa", "Bữa tối", "Ăn vặt", 
    "Healthy", "Món Á", "Món Âu", "Món nước", 
    "Món khô", "Món trộn", "Hải sản", "Cơm", 
    "Phở", "Bún", "Trà", "Đồ uống", "Bánh ngọt"
];

let editModal, successModal, deleteModal;

document.addEventListener("DOMContentLoaded", async () => {
    editModal = document.getElementById('editModal');
    successModal = document.getElementById('successModal');
    deleteModal = document.getElementById('deleteModal');

    await loadRecipes();
});

async function loadRecipes() {
    const tableBody = document.getElementById("table-recipes");
    try {
        const response = await fetch("/api/recipes");
        const data = await response.json();
        
        allRecipesData = data.recipes || [];
        allRecipesData = allRecipesData.map((item, idx) => ({ ...item, originalIndex: idx }));

        handleSearchAndSort();

    } catch (err) {
        console.error(err);
        tableBody.innerHTML = "<tr><td colspan='7' style='color:red; text-align:center'>Lỗi kết nối API!</td></tr>";
    }
}

function handleSearchAndSort() {
    const keyword = document.getElementById('search-input').value.toLowerCase();
    const dateValue = document.getElementById('filter_date').value;
    
    let filtered = allRecipesData.filter(item => {
        const name = (item.name || item.title || '').toLowerCase();
        const matchName = name.includes(keyword);

        let matchDate = true;
        if (dateValue) {
            const itemDateRaw = item.createdAt || item.created_at; 
            const itemDateStr = normalizeDate(itemDateRaw); 
            matchDate = (itemDateStr === dateValue);
        }

        return matchName && matchDate;
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

function normalizeDate(dateInput) {
    if (!dateInput) return "";
    if (typeof dateInput === 'string' && dateInput.includes('/')) {
        const parts = dateInput.split('/');
        if (parts.length === 3) return `${parts[2]}-${parts[1]}-${parts[0]}`; 
    }
    try {
        const d = new Date(dateInput);
        if (!isNaN(d.getTime())) return d.toISOString().split('T')[0];
    } catch (e) { return ""; }
    return "";
}

function formatDateVN(dateInput) {
    if (!dateInput) return "";
    if (typeof dateInput === 'string' && /^\d{2}\/\d{2}\/\d{4}$/.test(dateInput)) return dateInput;
    try {
        const d = new Date(dateInput);
        if (!isNaN(d.getTime())) {
            const day = String(d.getDate()).padStart(2, '0');
            const month = String(d.getMonth() + 1).padStart(2, '0');
            const year = d.getFullYear();
            return `${day}/${month}/${year}`;
        }
    } catch (e) {}
    return dateInput;
}

function updateTableDisplay() {
    const totalItems = currentFilteredData.length;
    const totalPages = Math.ceil(totalItems / rowsPerPage);

    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;

    const start = (currentPage - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    const paginatedItems = currentFilteredData.slice(start, end);

    renderTable(paginatedItems);
    renderPagination(totalItems, totalPages);
}

function renderTable(recipes) {
    const tableBody = document.getElementById("table-recipes");
    tableBody.innerHTML = ""; 

    if (recipes.length === 0) {
        tableBody.innerHTML = "<tr><td colspan='7' style='text-align:center'>Không tìm thấy công thức nào.</td></tr>";
        return;
    }

    recipes.forEach(item => {
        const row = document.createElement("tr");
        let displayImgUrl = item.cover_url || (item.images && item.images[0]) || '';
        const imgHtml = displayImgUrl ? `<img src="${displayImgUrl}" class="table_thumb" onerror="this.style.display='none'">` : ''; 
        
        const recipeName = item.name || item.title || "Chưa đặt tên";
        const author = item.authorName || 'Ẩn danh'; 
        const difficulty = item.difficulty || 'N/A'; 
        const dateDisplay = formatDateVN(item.createdAt || item.created_at);

        row.innerHTML = `
            <td>${item.id.substring(0, 6)}...</td>
            <td>${imgHtml}</td>
            <td><strong>${recipeName}</strong></td>
            <td>${author}</td>
            <td>${difficulty}</td>
            <td>${dateDisplay}</td>
            <td class="actions_cell">
                <div class="action_btns">
                    <a href="javascript:void(0)" onclick="openEditModal('${item.id}')"><img src="images/edit.png" title="Xem/Sửa"></a>
                    <a href="javascript:void(0)" onclick="openDeleteModal('${item.id}')"><img src="images/delete.png" title="Xóa"></a>
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

function toggleSortDropdown() {
    closeAllDropdowns('sort'); 
    const el = document.getElementById('sort_dropdown_content');
    const icon = document.getElementById('sort_dropdown_icon');
    el.classList.toggle('show');
    icon.classList.toggle('rotate');
}

function selectSortMode(mode, text) {
    currentSortMode = mode;
    document.getElementById('sort_display_text').innerText = text;
    toggleSortDropdown(); 
    handleSearchAndSort();
}

function closeAllModals() {
    if(editModal) editModal.classList.remove('active');
    if(successModal) successModal.classList.remove('active');
    if(deleteModal) deleteModal.classList.remove('active');
    closeAllDropdowns();
}

function openEditModal(id) {
    const recipe = allRecipesData.find(r => r.id === id);
    if (!recipe) return;
    
    currentEditId = id; 
    currentDeleteId = id; 

    let finalUrl = recipe.cover_url || (recipe.images && recipe.images[0]) || '';
    const imgElem = document.getElementById('m_image');
    if (finalUrl) { imgElem.src = finalUrl; imgElem.style.display = 'block'; } 
    else { imgElem.style.display = 'none'; }

    document.getElementById('m_name').value = recipe.name || recipe.title || '';
    document.getElementById('m_desc').value = recipe.description || '';
    document.getElementById('m_time').value = recipe.cookingTime || '';
    document.getElementById('m_difficulty').value = recipe.difficulty || '';
    document.getElementById('m_servings').value = recipe.servings || '';

    const ingList = document.getElementById('m_ingredients_list');
    ingList.innerHTML = '';
    if (recipe.ingredients && Array.isArray(recipe.ingredients)) {
        recipe.ingredients.forEach(ing => {
            let iName = typeof ing === 'string' ? ing : ing.name;
            if(typeof ing === 'object' && ing.quantity) iName += ` (${ing.quantity})`;
            ingList.innerHTML += `<div class="ing_row"><input type="text" value="${iName}" class="input_readonly" style="width:100%"></div>`;
        });
    }

    const stepList = document.getElementById('m_steps_list');
    stepList.innerHTML = '';
    if (recipe.steps && Array.isArray(recipe.steps)) {
        recipe.steps.forEach((step, index) => {
            let sContent = typeof step === 'string' ? step : step.content;
            stepList.innerHTML += `
                <div class="step_item">
                    <div class="step_header">Bước ${index + 1}</div>
                    <div class="step_content"><p>${sContent}</p></div>
                </div>`;
        });
    }

    document.getElementById('m_author_name').innerText = recipe.authorName || 'Không có dữ liệu';

    const currentTags = recipe.tags || (recipe.category ? [recipe.category] : []);
    renderTagChecklist(currentTags);
    updateTagSummary(currentTags);

    editModal.classList.add('active');
}

function toggleTagDropdown() {
    const isShow = document.getElementById('tag_dropdown_content').classList.contains('show');
    closeAllDropdowns();
    if(!isShow) {
        document.getElementById('tag_dropdown_content').classList.add('show');
        document.getElementById('tag_dropdown_icon').classList.add('rotate');
        document.getElementById('tag_search_input').value = "";
        filterTags();
    }
}

function renderTagChecklist(selectedTags) {
    const container = document.getElementById('tag_checklist_container');
    container.innerHTML = '';
    AVAILABLE_TAGS.forEach(tag => {
        const isChecked = selectedTags.includes(tag);
        const div = document.createElement('div');
        div.className = 'tag_check_item';
        div.innerHTML = `<input type="checkbox" value="${tag}" ${isChecked ? 'checked' : ''} onchange="onTagChange()"><span>${tag}</span>`;
        container.appendChild(div);
    });
}

function onTagChange() {
    const checkboxes = document.querySelectorAll('#tag_checklist_container input[type="checkbox"]');
    const selected = [];
    checkboxes.forEach(cb => { if(cb.checked) selected.push(cb.value); });
    updateTagSummary(selected);
}

function updateTagSummary(tags) {
    const summaryBox = document.getElementById('tag_summary_box');
    const icon = summaryBox.querySelector('.dropdown_icon'); 
    summaryBox.innerHTML = ''; 
    if (tags.length === 0) {
        summaryBox.innerHTML = '<span class="placeholder_text" style="color:#888; font-size:13px;">Chọn danh mục...</span>';
    } else {
        tags.forEach(tag => {
            const span = document.createElement('span');
            span.className = 'tag_pill';
            span.innerText = tag;
            summaryBox.appendChild(span);
        });
    }
    summaryBox.appendChild(icon);
}

function filterTags() {
    const filter = document.getElementById('tag_search_input').value.toLowerCase();
    const items = document.getElementsByClassName('tag_check_item');
    for (let item of items) {
        const text = item.innerText.toLowerCase();
        item.style.display = text.includes(filter) ? "flex" : "none";
    }
}

function closeAllDropdowns(except = null) {
    const ids = [
        {content: 'sort_dropdown_content', icon: 'sort_dropdown_icon'},
        {content: 'tag_dropdown_content', icon: 'tag_dropdown_icon'}
    ];
    ids.forEach(item => {
        if(except && item.content.includes(except)) return;
        const el = document.getElementById(item.content);
        const ic = document.getElementById(item.icon);
        if(el) el.classList.remove('show');
        if(ic) ic.classList.remove('rotate');
    });
}

async function handleSave() {
    if (!currentEditId) return;

    const checkboxes = document.querySelectorAll('#tag_checklist_container input[type="checkbox"]');
    const selectedTags = [];
    checkboxes.forEach(cb => { 
        if(cb.checked) selectedTags.push(cb.value); 
    });
    const saveBtn = document.querySelector('#editModal .btn_save_changes');
    const originalText = saveBtn.innerText; 
    saveBtn.disabled = true;
    saveBtn.style.opacity = "0.7";

    console.log("Đang gửi dữ liệu:", { id: currentEditId, tags: selectedTags });
    try {
        const response = await fetch(`/api/update-recipe-tags/${currentEditId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ tags: selectedTags })
        });

        if (response.ok) {
            editModal.classList.remove('active');
            successModal.classList.add('active');

            await loadRecipes();
        } else {
            const err = await response.json();
            alert("Lỗi khi lưu: " + (err.detail || "Không xác định"));
        }
    } catch (error) {
        console.error("Lỗi kết nối:", error);
        alert("Lỗi kết nối server!");
    } finally {
        saveBtn.innerText = originalText;
        saveBtn.disabled = false;
        saveBtn.style.opacity = "1";
    }
}

function openDeleteModal(id) { 
    currentDeleteId = id; deleteModal.classList.add('active'); 
}

async function confirmDeleteAction() {
    if (!currentDeleteId) return;
    try {
        const res = await fetch(`/api/recipes/${currentDeleteId}`, { method: 'DELETE' });
        if(res.ok) {
            closeAllModals(); 
            alert("Đã xóa thành công!");
            location.reload(); 
        } else { alert("Lỗi khi xóa."); }
    } catch(e) { alert("Lỗi kết nối server."); }
}

function exportToExcel() {
    if (!allRecipesData.length) { alert("Không có dữ liệu!"); return; }
    const data = allRecipesData.map((item, i) => ({
        "STT": i + 1, "ID": item.id,
        "Link ảnh": item.cover_url || (item.images && item.images[0]) || '',
        "Tên món": item.name || item.title, "Tác giả": item.authorName,
        "Độ khó": item.difficulty, "Ngày đăng": formatDateVN(item.createdAt || item.created_at)
    }));
    const ws = XLSX.utils.json_to_sheet(data);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "CongThuc");
    XLSX.writeFile(wb, `DS_Cong_Thuc_${new Date().toISOString().slice(0,10)}.xlsx`);
}

window.onclick = function(e) {
    if (e.target == editModal || e.target == successModal || e.target == deleteModal) closeAllModals();
    if (!e.target.closest('.tag_manager')) {
        closeAllDropdowns();
    }
}