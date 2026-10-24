(() => {
  const form = document.querySelector("[data-seat-form]");
  if (!form) return;
  const inputs = form.querySelector("[data-seat-inputs]");
  const status = form.querySelector("[data-seat-selection]");
  const submit = form.querySelector("[data-next-products]");

  function updateSelection() {
    const selected = [...document.querySelectorAll(".seat.selected")];
    inputs.replaceChildren();
    selected.forEach(seat => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = "assentoIds";
      input.value = seat.dataset.seatId;
      inputs.append(input);
    });
    submit.disabled = selected.length === 0;
    status.textContent = selected.length
      ? "Assentos " + selected.map(seat => seat.dataset.seatLabel).join(", ") + " selecionados (" + selected.length + ")."
      : "Selecione um ou mais assentos livres no mapa.";
  }

  document.querySelectorAll(".seat.available").forEach(seat => {
    seat.addEventListener("click", () => {
      seat.classList.toggle("selected");
      updateSelection();
    });
  });
  updateSelection();
})();
