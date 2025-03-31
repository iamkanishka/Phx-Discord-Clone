export default {
    mounted() {
      this.el.addEventListener("scroll", () => {
        let nearBottom = this.isNearBottom();
        this.el.setAttribute("data-near-bottom", nearBottom);
        
        let newMsgBtn = document.getElementById("new-messages-btn");
        if (newMsgBtn) {
          newMsgBtn.style.display = nearBottom ? "none" : "block"; // Show if not at bottom
        }
      });
  
      this.observer = new IntersectionObserver((entries) => {
        if (entries[0].isIntersecting) {
          this.pushEvent("load_more", { scrollTop: this.el.scrollTop });
        }
      });
  
      this.observeLastMessage();
  
      this.handleEvent("restore_scroll", ({ scrollTop }) => {
        this.el.scrollTop = scrollTop;
      });
  
      this.handleEvent("scroll_to_bottom", () => {
        if (this.isNearBottom()) {
          this.smoothScrollToBottom(); // Smooth scrolling
        } else {
          this.showNewMessagesButton(); // Show "New Messages" button
        }
      });
  
      let newMsgBtn = document.getElementById("new-messages-btn");
      if (newMsgBtn) {
        newMsgBtn.addEventListener("click", () => {
          this.smoothScrollToBottom();
        });
      }
    },
  
    updated() {
      this.observeLastMessage();
    },
  
    observeLastMessage() {
      let messages = this.el.querySelectorAll("div.message");
      let firstMessage = messages[0];
  
      if (firstMessage) {
        let prevHeight = this.el.scrollHeight;
        this.observer.observe(firstMessage);
  
        setTimeout(() => {
          let newHeight = this.el.scrollHeight;
          this.el.scrollTop += newHeight - prevHeight;
        }, 10);
      }
    },
  
    isNearBottom() {
      return this.el.scrollTop + this.el.clientHeight >= this.el.scrollHeight - 50;
    },
  
    smoothScrollToBottom() {
      this.el.scrollTo({ top: this.el.scrollHeight, behavior: "smooth" });
      let newMsgBtn = document.getElementById("new-messages-btn");
      if (newMsgBtn) {
        newMsgBtn.style.display = "none"; // Hide button after scrolling
      }
    },
  
    showNewMessagesButton() {
      let newMsgBtn = document.getElementById("new-messages-btn");
      if (newMsgBtn) {
        newMsgBtn.style.display = "block"; // Show button
      }
    },
  
    destroyed() {
      this.observer.disconnect();
    }
}
  