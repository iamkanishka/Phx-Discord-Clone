// assets/js/hooks.js
export default {
    mounted() {
      // Store the element ID from data attribute
      this.elementId = this.el.dataset.elementId;
  
      // Handle specific event from LiveView
      this.handleEvent("remove_element", ({ id }) => {
        this.removeElement(id || this.elementId);
      });
  
      // Add click listener to document for anywhere click removal
      this.clickHandler = (event) => {
        // Prevent removal if clicking the hook element itself
        if (!this.el.contains(event.target)) {
          this.removeElement(this.elementId);
        }
      };
  
      // Add the document click listener
      document.addEventListener("click", this.clickHandler);
    },
  
    // Clean up when hook is removed
    destroyed() {
      document.removeEventListener("click", this.clickHandler);
    },
  
    // Method to remove element and its children
    removeElement(id) {
      const element = document.getElementById(id);
      if (element) {
        element.remove();
      }
    }
  };
  
 