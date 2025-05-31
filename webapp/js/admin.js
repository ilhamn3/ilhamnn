document.addEventListener('DOMContentLoaded', () => {
  // Calendar Functionality
  const prevMonthBtn = document.getElementById('prevMonth');
  const nextMonthBtn = document.getElementById('nextMonth');
  const monthYear = document.getElementById('monthYear');
  const calendarBody = document.getElementById('calendarBody');
  let currentDate = new Date(2025, 4, 6); // May 6, 2025
  let today = new Date(2025, 4, 6);

  function generateCalendar(date) {
    const year = date.getFullYear();
    const month = date.getMonth();
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    monthYear.textContent = date.toLocaleString('default', { month: 'long', year: 'numeric' });

    let calendarHTML = '';
    let day = 1;

    for (let i = 0; i < 6; i++) {
      calendarHTML += '<tr>';
      for (let j = 0; j < 7; j++) {
        if (i === 0 && j < firstDay) {
          calendarHTML += '<td></td>';
        } else if (day > daysInMonth) {
          calendarHTML += '<td></td>';
        } else {
          const isToday = day === today.getDate() && month === today.getMonth() && year === today.getFullYear();
          const isHoliday = (month === 4 && day === 10); // Example holiday
          calendarHTML += `<td class="${isToday ? 'today' : ''} ${isHoliday ? 'holiday' : ''}">${day}</td>`;
          day++;
        }
      }
      calendarHTML += '</tr>';
    }
    calendarBody.innerHTML = calendarHTML;
  }

  prevMonthBtn.addEventListener('click', () => {
    currentDate.setMonth(currentDate.getMonth() - 1);
    generateCalendar(currentDate);
  });

  nextMonthBtn.addEventListener('click', () => {
    currentDate.setMonth(currentDate.getMonth() + 1);
    generateCalendar(currentDate);
  });

  generateCalendar(currentDate);

  // Announcement Carousel
  const announcements = document.querySelectorAll('.announcement');
  const prevAnnouncementBtn = document.getElementById('prevAnnouncement');
  const nextAnnouncementBtn = document.getElementById('nextAnnouncement');
  let currentAnnouncement = 0;

  function showAnnouncement(index) {
    announcements.forEach((ann, i) => {
      ann.classList.toggle('active', i === index);
    });
  }

  prevAnnouncementBtn.addEventListener('click', () => {
    currentAnnouncement = (currentAnnouncement - 1 + announcements.length) % announcements.length;
    showAnnouncement(currentAnnouncement);
  });

  nextAnnouncementBtn.addEventListener('click', () => {
    currentAnnouncement = (currentAnnouncement + 1) % announcements.length;
    showAnnouncement(currentAnnouncement);
  });

  showAnnouncement(currentAnnouncement);
});
