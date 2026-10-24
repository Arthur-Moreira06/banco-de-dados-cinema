(() => {
  const form = document.querySelector("[data-seat-form]");
  const session = document.querySelector("[data-ticket-movie]");
  if (!form || !session) return;

  const sessionProgram = document.querySelector("[data-session-program]");
  if (sessionProgram) sessionProgram.hidden = true;

  const steps = [...form.querySelectorAll("[data-ticket-step]")];
  const productCards = [...form.querySelectorAll(".ticket-product-card")];
  const selectedSeats = () => [...document.querySelectorAll(".seat.selected")];
  const typeSelect = form.querySelector("#tipo");
  const documentSelect = form.querySelector("#documentoId");
  const money = amount => new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" }).format(amount);
  const basePrice = Number(session.dataset.ticketPrice || 0);
  let currentStep = "seat";

  const quantityOf = card => Number(card.querySelector("[data-product-quantity]").dataset.productQuantity || 0);
  const productTotal = () => productCards.reduce((sum, card) => sum + quantityOf(card) * Number(card.dataset.productPrice), 0);
  const ticketPrice = () => (typeSelect.value === "Meia-entrada" ? basePrice / 2 : basePrice) * selectedSeats().length;

  function showStep(name) {
    currentStep = name;
    steps.forEach(step => { step.hidden = step.dataset.ticketStep !== name; });
    const checkoutFields = form.querySelectorAll("#clienteId, #tipo, #documentoId, #pagamento");
    checkoutFields.forEach(field => { field.disabled = name !== "checkout"; });
    form.querySelector("[data-submit-seat]").disabled = name !== "checkout";
    form.querySelector("[data-seat-stage]").hidden = name !== "seat";
    refreshSummary();
    if (name === "checkout") updateCheckoutTotal();
  }

  function refreshSummary() {
    form.querySelector("[data-summary-movie]").textContent = session.dataset.ticketMovie;
    form.querySelector("[data-summary-session]").textContent = session.dataset.ticketSession;
    const seats = selectedSeats();
    const seatLabels = seats.map(seat => seat.dataset.seatLabel);
    form.querySelector("[data-summary-seats]").textContent = seatLabels.length ? "Assentos " + seatLabels.join(", ") : "Nenhum assento selecionado";
    form.querySelector("[data-summary-type]").textContent = `Ingresso ${typeSelect.value}`;
    const chosen = productCards.filter(card => quantityOf(card) > 0);
    form.querySelector("[data-next-summary]").textContent = chosen.length ? "Continuar" : "Continuar sem produtos";
    const renderItems = list => {
      list.replaceChildren();
      if (chosen.length === 0) {
        const empty = document.createElement("li");
        empty.textContent = "Nenhum produto selecionado";
        empty.className = "ticket-side-empty";
        list.append(empty);
      }
      chosen.forEach(card => {
        const line = document.createElement("li");
        line.textContent = `${quantityOf(card)}× ${card.dataset.productName} — ${money(quantityOf(card) * Number(card.dataset.productPrice))}`;
        list.append(line);
      });
    };
    form.querySelectorAll("[data-summary-products]").forEach(renderItems);
    form.querySelectorAll("[data-sidebar-products]").forEach(renderItems);
    form.querySelectorAll("[data-sidebar-seats]").forEach(item => {
      item.textContent = seatLabels.length ? "Assentos " + seatLabels.join(", ") : "Nenhum assento selecionado";
    });
    form.querySelector("[data-summary-empty]").hidden = chosen.length > 0;
    form.querySelector("[data-summary-products]").hidden = chosen.length === 0;
    const total = money(ticketPrice() + productTotal());
    form.querySelector("[data-summary-total]").textContent = total;
    form.querySelectorAll("[data-sidebar-total]").forEach(item => { item.textContent = total; });
  }

  function updateCheckoutTotal() {
    documentSelect.required = typeSelect.value === "Meia-entrada";
    if (typeSelect.value !== "Meia-entrada") documentSelect.value = "";
    refreshSummary();
  }

  form.querySelector("[data-next-products]").addEventListener("click", () => {
    if (!selectedSeats().length) return;
    showStep("products");
  });
  form.querySelector("[data-back-seat]").addEventListener("click", () => showStep("seat"));
  form.querySelector("[data-next-summary]").addEventListener("click", () => showStep("summary"));
  form.querySelector("[data-back-products]").addEventListener("click", () => showStep("products"));
  form.querySelector("[data-next-checkout]").addEventListener("click", () => showStep("checkout"));
  form.querySelector("[data-back-summary]").addEventListener("click", () => showStep("summary"));

  form.querySelectorAll("[data-ticket-filter]").forEach(button => button.addEventListener("click", () => {
    form.querySelectorAll("[data-ticket-filter]").forEach(filter => filter.classList.toggle("is-active", filter === button));
    productCards.forEach(card => { card.hidden = button.dataset.ticketFilter !== "Todas" && card.dataset.category !== button.dataset.ticketFilter; });
  }));

  productCards.forEach(card => {
    const image = card.querySelector(".ticket-product-photo");
    image.style.backgroundImage = `url("${window.cinemaProductImage(card.dataset.category, card.dataset.productName)}")`;
    image.style.backgroundSize = "cover";
    image.style.backgroundPosition = "center";
    const quantity = card.querySelector("[data-product-quantity]");
    const hiddenInput = card.querySelector("[data-product-input]");
    card.querySelectorAll("[data-product-step]").forEach(button => button.addEventListener("click", () => {
      if (Number(card.dataset.stock) <= 0) return;
      const next = Math.max(0, Math.min(Number(card.dataset.stock), quantityOf(card) + Number(button.dataset.productStep)));
      quantity.dataset.productQuantity = String(next);
      quantity.textContent = String(next);
      hiddenInput.value = String(next);
      if (currentStep === "checkout") updateCheckoutTotal();
      else refreshSummary();
    }));
  });

  typeSelect.addEventListener("change", updateCheckoutTotal);
  form.addEventListener("submit", event => {
    if (!selectedSeats().length || currentStep !== "checkout") {
      event.preventDefault();
      return;
    }
    if (typeSelect.value === "Meia-entrada" && !documentSelect.value) {
      event.preventDefault();
      documentSelect.focus();
      documentSelect.reportValidity();
    }
  });
})();
