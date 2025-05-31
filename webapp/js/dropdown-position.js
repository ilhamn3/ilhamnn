document.addEventListener('shown.bs.dropdown', function (e) {
    const dropdownMenu = e.target.nextElementSibling;
    const dropdownRect = dropdownMenu.getBoundingClientRect();
    const viewportWidth = window.innerWidth;

    // Check if the dropdown extends beyond the right edge of the viewport
    if (dropdownRect.right > viewportWidth) {
        // Calculate how much to shift left to keep it within the viewport
        const overflow = dropdownRect.right - viewportWidth;
        dropdownMenu.style.right = 'auto';
        dropdownMenu.style.left = `-${overflow + 10}px`; // Add 10px buffer
    } else {
        // Reset to default if no overflow
        dropdownMenu.style.right = '0';
        dropdownMenu.style.left = 'auto';
    }
});