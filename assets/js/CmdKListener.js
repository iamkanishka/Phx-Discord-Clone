export default {
  mounted() {
    this.handleKeyDown = (event) => {
      const isMac = navigator.platform.toUpperCase().includes("MAC");
      const isCmdK = isMac ? event.metaKey && event.key === "k" : event.ctrlKey && event.key === "k";

      if (isCmdK) {
        event.preventDefault();
        this.pushEvent("cmd_k_pressed", {});
      }
    };

    window.addEventListener("keydown", this.handleKeyDown);
  },

  destroyed() {
    window.removeEventListener("keydown", this.handleKeyDown);
  }
};

 
