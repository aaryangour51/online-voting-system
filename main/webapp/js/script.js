// Online Voting System - Client Scripts

// Auto-dismiss alerts after 5 seconds
document.addEventListener('DOMContentLoaded', () => {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transition = 'opacity 0.5s';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });

    // Uppercase voter ID input
    const voterIdInput = document.querySelector('input[name="voterId"]');
    if (voterIdInput) {
        voterIdInput.addEventListener('input', e => {
            e.target.value = e.target.value.toUpperCase();
        });
    }
});