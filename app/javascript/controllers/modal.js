document.addEventListener("turbo:load", function() {
    document.querySelectorAll("[data-modal-target]").forEach(button => {
      button.addEventListener("click", function(event) {
        event.preventDefault();
        const modalId = button.getAttribute("data-modal-target");
        const modal = document.getElementById(modalId);
  
        fetch(button.getAttribute("href"))
          .then(response => response.text())
          .then(html => {
            modal.querySelector("#modal_body").innerHTML = html;
            modal.classList.remove("hidden");
          });
      });
    });
  
    document.querySelectorAll(".close").forEach(button => {
      button.addEventListener("click", function() {
        button.closest(".modal").classList.add("hidden");
      });
    });
  
    window.addEventListener("click", function(event) {
      document.querySelectorAll(".modal").forEach(modal => {
        if (event.target == modal) {
          modal.classList.add("hidden");
        }
      });
    });
  });
  