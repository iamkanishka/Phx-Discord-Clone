export default {
  mounted() {
    const dropzone = this.el.closest("#dropzone"); // Now targeting the div

    const handleFile = (file) => {
      if (file) {
        let reader = new FileReader();
        reader.onload = (event) => {
          let imageDataSplit = event.target.result.split(",") 
         
          this.pushEvent("file_selected", {
            name: file.name,
            size: file.size,
            type: file.type,
            content: imageDataSplit[1], //base64Content
            extras: imageDataSplit[0]
          });
        };
        reader.readAsDataURL(file);
      }
    };

    // Handle input change event
    this.el.addEventListener("change", (e) => {
      let file = e.target.files[0];
      handleFile(file);
    });

    // Handle drag-and-drop
    dropzone.addEventListener("dragover", (e) => {
      e.preventDefault(); // Important: Allows drop
      dropzone.classList.add("drag-over"); // Optional: Styling effect
    });

    dropzone.addEventListener("dragleave", () => {
      dropzone.classList.remove("drag-over");
    });

    dropzone.addEventListener("drop", (e) => {
      e.preventDefault(); // Prevents the browser from opening the file
      dropzone.classList.remove("drag-over");

      if (e.dataTransfer.files.length > 0) {
        let file = e.dataTransfer.files[0];
        handleFile(file);
      }
    });
  },
};
