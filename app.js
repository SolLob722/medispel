document.addEventListener('DOMContentLoaded', () => {
  const wa = document.createElement('a');
  wa.href = 'https://wa.me/27766325239?text=Hi%20MediHub%20Support';
  wa.target = '_blank';
  wa.rel = 'noopener noreferrer';
  wa.className = 'whatsapp-float';
  wa.setAttribute('aria-label', 'Chat on WhatsApp');
  wa.innerHTML = '<i class="fab fa-whatsapp"></i>';
  document.body.appendChild(wa);
});
