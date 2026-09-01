document.addEventListener('DOMContentLoaded', () => {
    const DEFAULT_TEST_URL = 'http://localhost:5678/webhook-test/greeting';
    const DEFAULT_PROD_URL = 'http://localhost:5678/webhook/greeting';
    const STORAGE_KEY = 'n8n_greeting_webhook_url';

    // DOM Elements
    const webhookUrlInput = document.getElementById('webhookUrl');
    const btnResetUrl = document.getElementById('btnResetUrl');
    const btnModeTest = document.getElementById('btnModeTest');
    const btnModeProd = document.getElementById('btnModeProd');

    const form = document.getElementById('greetingForm');
    const nameInput = document.getElementById('name');
    const ageInput = document.getElementById('age');
    const submitBtn = document.getElementById('submitBtn');

    const presetXiaoMing = document.getElementById('presetXiaoMing');
    const presetXiaoMei = document.getElementById('presetXiaoMei');
    const presetEmpty = document.getElementById('presetEmpty');

    const resultArea = document.getElementById('resultArea');
    const statusBadge = document.getElementById('statusBadge');
    const latencyBadge = document.getElementById('latencyBadge');
    const responseTimestamp = document.getElementById('responseTimestamp');

    const tabVisual = document.getElementById('tabVisual');
    const tabJson = document.getElementById('tabJson');
    const viewVisual = document.getElementById('viewVisual');
    const viewJson = document.getElementById('viewJson');
    const btnCopyJson = document.getElementById('btnCopyJson');

    const responseBox = document.getElementById('responseBox');
    const greetingIcon = document.getElementById('greetingIcon');
    const greetingText = document.getElementById('greetingText');
    const metaUser = document.getElementById('metaUser');
    const metaTime = document.getElementById('metaTime');
    const metaIp = document.getElementById('metaIp');
    const jsonCodeBlock = document.getElementById('jsonCodeBlock');

    let currentResponseData = null;

    // 1. 初始化 Webhook URL
    function initUrl() {
        const savedUrl = localStorage.getItem(STORAGE_KEY);
        webhookUrlInput.value = savedUrl || DEFAULT_TEST_URL;
        updateModeButtons(webhookUrlInput.value);
    }

    function updateModeButtons(url) {
        if (url.includes('/webhook-test/')) {
            btnModeTest.classList.add('active');
            btnModeProd.classList.remove('active');
        } else if (url.includes('/webhook/')) {
            btnModeProd.classList.add('active');
            btnModeTest.classList.remove('active');
        } else {
            btnModeTest.classList.remove('active');
            btnModeProd.classList.remove('active');
        }
    }

    webhookUrlInput.addEventListener('input', () => {
        localStorage.setItem(STORAGE_KEY, webhookUrlInput.value.trim());
        updateModeButtons(webhookUrlInput.value.trim());
    });

    btnResetUrl.addEventListener('click', () => {
        webhookUrlInput.value = DEFAULT_TEST_URL;
        localStorage.setItem(STORAGE_KEY, DEFAULT_TEST_URL);
        updateModeButtons(DEFAULT_TEST_URL);
    });

    btnModeTest.addEventListener('click', () => {
        let url = webhookUrlInput.value.trim();
        if (url.includes('/webhook/')) {
            url = url.replace('/webhook/', '/webhook-test/');
        } else if (!url.includes('/webhook-test/')) {
            url = DEFAULT_TEST_URL;
        }
        webhookUrlInput.value = url;
        localStorage.setItem(STORAGE_KEY, url);
        updateModeButtons(url);
    });

    btnModeProd.addEventListener('click', () => {
        let url = webhookUrlInput.value.trim();
        if (url.includes('/webhook-test/')) {
            url = url.replace('/webhook-test/', '/webhook/');
        } else if (!url.includes('/webhook/')) {
            url = DEFAULT_PROD_URL;
        }
        webhookUrlInput.value = url;
        localStorage.setItem(STORAGE_KEY, url);
        updateModeButtons(url);
    });

    // 2. 快速填入範例按鈕
    presetXiaoMing.addEventListener('click', () => {
        nameInput.value = '王小明';
        ageInput.value = '25';
        nameInput.focus();
    });

    presetXiaoMei.addEventListener('click', () => {
        nameInput.value = '林小美';
        ageInput.value = '18';
        nameInput.focus();
    });

    presetEmpty.addEventListener('click', () => {
        nameInput.value = '';
        ageInput.value = '';
        nameInput.focus();
    });

    // 3. 分頁切換
    tabVisual.addEventListener('click', () => {
        tabVisual.classList.add('active');
        tabJson.classList.remove('active');
        viewVisual.classList.add('active');
        viewJson.classList.remove('active');
    });

    tabJson.addEventListener('click', () => {
        tabJson.classList.add('active');
        tabVisual.classList.remove('active');
        viewJson.classList.add('active');
        viewVisual.classList.remove('active');
    });

    // 4. 一鍵複製 JSON
    btnCopyJson.addEventListener('click', async () => {
        if (!currentResponseData) return;
        try {
            await navigator.clipboard.writeText(JSON.stringify(currentResponseData, null, 2));
            const oldText = btnCopyJson.textContent;
            btnCopyJson.textContent = '✅ 已複製！';
            setTimeout(() => {
                btnCopyJson.textContent = oldText;
            }, 2000);
        } catch (err) {
            alert('複製失敗，請手動複製！');
        }
    });

    // 5. 表單提交發送 Webhook
    form.addEventListener('submit', async (e) => {
        e.preventDefault();

        const targetUrl = webhookUrlInput.value.trim();
        if (!targetUrl) {
            alert('請先輸入有效的 n8n Webhook 網址！');
            webhookUrlInput.focus();
            return;
        }

        // 組裝 Payload
        const payload = {
            name: nameInput.value.trim(),
            age: ageInput.value ? parseInt(ageInput.value, 10) : undefined
        };

        // UI 狀態切換：載入中
        submitBtn.classList.add('loading');
        submitBtn.setAttribute('disabled', 'true');

        const startTime = performance.now();
        const requestTimeStr = new Date().toLocaleTimeString();

        try {
            const response = await fetch(targetUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(payload)
            });

            const latency = Math.round(performance.now() - startTime);
            const responseData = await response.json().catch(() => ({ message: '無法解析伺服器回傳的 JSON' }));
            currentResponseData = responseData;

            // 渲染回應結果
            renderResponse({
                status: response.status,
                statusText: response.statusText,
                ok: response.ok,
                latency: latency,
                timeStr: requestTimeStr,
                data: responseData
            });

        } catch (error) {
            const latency = Math.round(performance.now() - startTime);
            console.error('Webhook 呼叫失敗:', error);

            const errData = {
                status: 'network_error',
                error: error.message || '連線失敗',
                tip: '請確認：1. n8n 是否正在運行？ 2. Webhook 網址是否正確？ 3. 是否已在 n8n 點擊「Test step」等待事件？'
            };
            currentResponseData = errData;

            renderResponse({
                status: 0,
                statusText: 'Network / CORS Error',
                ok: false,
                latency: latency,
                timeStr: requestTimeStr,
                data: errData
            });
        } finally {
            submitBtn.classList.remove('loading');
            submitBtn.removeAttribute('disabled');
        }
    });

    // 6. 渲染回應資料到 UI
    function renderResponse({ status, statusText, ok, latency, timeStr, data }) {
        resultArea.classList.remove('hidden');

        // 更新時間與延遲
        latencyBadge.textContent = `⏱️ ${latency} ms`;
        responseTimestamp.textContent = timeStr;

        // 更新狀態標籤
        statusBadge.className = 'status-badge';
        if (status === 200) {
            statusBadge.classList.add('status-200');
            statusBadge.textContent = `200 OK`;
            responseBox.className = 'response-box';
            greetingIcon.textContent = '🎉';
        } else if (status === 400) {
            statusBadge.classList.add('status-400');
            statusBadge.textContent = `400 Bad Request`;
            responseBox.className = 'response-box box-error';
            greetingIcon.textContent = '⚠️';
        } else {
            statusBadge.classList.add('status-error');
            statusBadge.textContent = status ? `${status} ${statusText}` : '連線失敗 (CORS / 離線)';
            responseBox.className = 'response-box box-error';
            greetingIcon.textContent = '🚫';
        }

        // 視覺化卡片內容
        if (data.greeting) {
            greetingText.textContent = data.greeting;
        } else if (data.error) {
            greetingText.textContent = `❌ ${data.error}` + (data.hint ? `\n💡 建議：${data.hint}` : '');
        } else {
            greetingText.textContent = JSON.stringify(data);
        }

        metaUser.textContent = `👤 訪客：${data.userName || (nameInput.value.trim() || '未提供')}`;
        metaTime.textContent = `🕒 時間：${data.time || timeStr}`;
        metaIp.textContent = `🌐 客戶端：${data.clientIp || '本機端點'}`;

        // JSON Code 渲染
        jsonCodeBlock.textContent = JSON.stringify(data, null, 2);
    }

    // 啟動初始化
    initUrl();
});
