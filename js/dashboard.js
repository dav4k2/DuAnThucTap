document.addEventListener("DOMContentLoaded", async () => {
    await loadDashboardStats();
});

async function loadDashboardStats() {
    try {
        const res = await fetch('/api/dashboard-stats');
        if (!res.ok) throw new Error("Lỗi kết nối API");
        
        const data = await res.json();

        // Cập nhật số liệu tổng & Sidebar
        if (data.summary) {
            updateText('total-users', data.summary.total_users);
            updateText('total-recipes', data.summary.total_recipes);
            updateText('new-users-month', "+" + (data.summary.new_users_month || 0));
            updateText('new-recipes-month', "+" + (data.summary.new_recipes_month || 0));
        }

        if (data.charts) {
            initCharts(data.charts);
        }

        if (data.lists) {
            renderTable('new-users-table', data.lists.new_users, ['id', 'name', 'email', 'date']);
            renderTable('new-recipes-table', data.lists.new_recipes, ['id', 'title', 'author', 'date']);
        }

    } catch (error) {
        console.error("Lỗi tải thống kê:", error);
    }
}

function updateText(id, value) {
    const el = document.getElementById(id);
    if(el) el.innerText = value || 0;
}

// Render bảng 
function renderTable(tbodyId, dataList, fields) {
    const tbody = document.getElementById(tbodyId);
    if (!tbody) return;

    tbody.innerHTML = "";

    if (!dataList || dataList.length === 0) {
        tbody.innerHTML = `<tr><td colspan="${fields.length}" style="text-align:center; padding: 20px; color: #999;">Không có dữ liệu mới trong tháng này.</td></tr>`;
        return;
    }

    dataList.forEach(item => {
        const tr = document.createElement('tr');
        
        fields.forEach(field => {
            const td = document.createElement('td');
            let val = item[field];
            if (field === 'id' && val && val.length > 8) {
                val = val.substring(0, 8) + '...';
                td.title = item[field]; 
                td.style.color = '#888';
                td.style.fontSize = '12px';
            }
            
            td.innerText = val || 'N/A';
            tr.appendChild(td);
        });
        
        tbody.appendChild(tr);
    });
}

// Hàm khởi tạo biểu đồ
function initCharts(chartData) {
    // Biểu đồ tròn
    const pieCanvas = document.getElementById('pieChart');
    if (pieCanvas) {
        new Chart(pieCanvas.getContext('2d'), {
            type: 'pie',
            data: {
                labels: (chartData.pie && chartData.pie.labels.length) ? chartData.pie.labels : ['Chưa có dữ liệu'],
                datasets: [{
                    data: (chartData.pie && chartData.pie.data.length) ? chartData.pie.data : [1], 
                    backgroundColor: ['#FFC107', '#4CAF50', '#2196F3', '#FF5722', '#9C27B0'],
                    borderWidth: 1,
                    borderColor: '#fff'
                }]
            },
            options: { 
                responsive: true, 
                maintainAspectRatio: false, 
                plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 15 } } } 
            }
        });
    }
    
    // Biểu đồ cột
    const barCanvas = document.getElementById('barChart');
    if (barCanvas) {
        new Chart(barCanvas.getContext('2d'), {
            type: 'bar',
            data: {
                labels: chartData.bar ? chartData.bar.labels : [],
                datasets: [{
                    label: 'Rating',
                    data: chartData.bar ? chartData.bar.data : [],
                    backgroundColor: '#2a7be2', 
                    borderRadius: 4
                }]
            },
            options: {
                indexAxis: 'y', 
                responsive: true, 
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { x: { beginAtZero: true, max: 5 } }
            }
        });
    }

    // Biểu đồ đường
    const lineCanvas = document.getElementById('lineChart');
    if (lineCanvas) {
        new Chart(lineCanvas.getContext('2d'), {
            type: 'line',
            data: {
                labels: chartData.line ? chartData.line.labels : [],
                datasets: [{
                    label: 'Người dùng',
                    data: chartData.line ? chartData.line.data : [],
                    borderColor: '#ef5350', 
                    backgroundColor: 'rgba(239, 83, 80, 0.1)',
                    fill: true, 
                    tension: 0.3,
                    pointRadius: 4,
                    pointBackgroundColor: '#ef5350'
                }]
            },
            options: {
                responsive: true, 
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, ticks: { precision: 0 } } }
            }
        });
    }
}