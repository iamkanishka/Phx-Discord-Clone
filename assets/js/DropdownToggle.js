export default {
  mounted() {
    this.menu = document.getElementById(this.el.dataset.menuId);

    if (!this.menu) {
      console.error("Dropdown menu not found!");
      return;
    }

    // Bind the function to ensure `this` refers to the hook instance
    this.handleOutsideClick = this.handleOutsideClick.bind(this);

    this.el.addEventListener("click", (e) => {
      e.stopPropagation();
      this.toggleDropdown();
    });

    // Listen for outside clicks
    window.addEventListener("click", this.handleOutsideClick);
  },

  destroyed() {
    // Remove event listener when component is destroyed
    window.removeEventListener("click", this.handleOutsideClick);
  },

  toggleDropdown() {
    if (this.menu) {
      const isHidden = this.menu.classList.contains("hidden");
      document
        .querySelectorAll(".dropdown-menu")
        .forEach((menu) => menu.classList.add("hidden"));
      if (isHidden) {
        this.menu.classList.remove("hidden");
      } else {
        this.menu.classList.add("hidden");
      }
    }
  },

  closeDropdown() {
    if (this.menu && !this.menu.classList.contains("hidden")) {
      this.menu.classList.add("hidden");
    }
  },

  handleOutsideClick(event) {
    // Close dropdown if click is outside the menu and button
    if (
      this.menu &&
      !this.el.contains(event.target) &&
      !this.menu.contains(event.target)
    ) {
      this.closeDropdown();
    }
  },
};
