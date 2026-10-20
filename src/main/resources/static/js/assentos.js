(() => {
  const form = document.querySelector("[data-seat-form]");
  if (!form) return;
  const hidden = form.querySelector("#assentoId");
  const status = form.querySelector("[data-seat-selection]");
  const submit = form.querySelector("[data-submit-seat]");
  document.querySelectorAll(".seat.available").forEach(seat => {
    seat.addEventListener("click", () => {
      document.querySelectorAll(".seat.selected").forEach(item => item.classList.remove("selected"));
      seat.classList.add("selected");
      hidden.value = seat.dataset.seatId;
      status.textContent = `Assento ${seat.dataset.seatLabel} selecionado.`;
      submit.disabled = false;
    });
  });
})();
