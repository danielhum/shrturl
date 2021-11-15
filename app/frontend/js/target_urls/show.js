let copyTooltip = "Copy to Clipboard";

function copyToClipboard(input) {
    input.select();
    input.setSelectionRange(0, 99999);
    navigator.clipboard.writeText(input.value);
}
function showCopiedTooltip(btn) {
    btn.setAttribute("data-bs-original-title", "Copied");
    let tooltip = bootstrap.Tooltip.getInstance(btn);
    tooltip.show();
    btn.setAttribute("data-bs-original-title", copyTooltip);
}

document.addEventListener("DOMContentLoaded", function(){
    let copyBtns = [].slice.call(document.getElementsByClassName("copy-btn"));
    copyBtns.map(function(el){
        el.title = copyTooltip;
        return new bootstrap.Tooltip(el);
    });
    copyBtns.forEach(function(el) {
        el.onclick = function() {
            copyToClipboard(el.previousElementSibling);
            showCopiedTooltip(el);
        }
    });
});
