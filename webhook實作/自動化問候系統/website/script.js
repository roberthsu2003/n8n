document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('greetingForm');
    const submitBtn = document.getElementById('submitBtn');
    const resultArea = document.getElementById('resultArea');
    const greetingText = document.getElementById('greetingText');
    const timestampText = document.getElementById('timestampText');

    // Replace this with your actual n8n Webhook URL (Production)
    // IMPORTANT: Ensure your n8n instance allows CORS or you are using a tunnel that handles it.
    const WEBHOOK_URL = 'https://superinnocent-hillary-unwholesome.ngrok-free.dev/webhook/greeting';

    form.addEventListener('submit', async (e) => {
        e.preventDefault();

        // UI State: Loading
        submitBtn.classList.add('loading');
        submitBtn.setAttribute('disabled', true);
        resultArea.classList.remove('show'); // Hide previous result temporarily

        // Gather data
        const formData = new FormData(form);
        const data = {
            name: formData.get('name'),
            age: parseInt(formData.get('age'), 10)
        };

        try {
            const response = await fetch(WEBHOOK_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    // 'Accept': 'application/json' 
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) {
                throw new Error(`Server returned ${response.status} ${response.statusText}`);
            }

            const result = await response.json();

            // Render result
            // result structure based on n8n workflow: { greeting: "...", time: "..." }
            displayResult(result);

        } catch (error) {
            console.error('Error:', error);
            alert('發生錯誤: ' + error.message);
        } finally {
            // UI State: Reset
            submitBtn.classList.remove('loading');
            submitBtn.removeAttribute('disabled');
        }
    });

    function displayResult(data) {
        // Show container
        resultArea.classList.remove('hidden');
        // Force reflow
        void resultArea.offsetWidth;
        resultArea.classList.add('show');

        // Set content
        greetingText.textContent = data.greeting || "未收到問候訊息";
        timestampText.textContent = data.time || new Date().toLocaleString();
    }
});
