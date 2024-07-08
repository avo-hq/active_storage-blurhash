import { decode } from "blurhash";

window.ActiveStorageBlurhash = {
  observer: new MutationObserver((mutationList, observer) => {
    mutationList.forEach(({ type, target, addedNodes, attributeName }) => {
      switch (type) {
        case "childList":
          if (addedNodes.length === 0) return;

          Array.from(addedNodes)
            .filter((node) => {
              try {
                return "blurhash" in node.dataset;
              } catch (e) {
                return false;
              }
            })
            .forEach((node) => {
              window.ActiveStorageBlurhash.renderAndLoad(node);
            });
          break;
        case "attributes":
          window.ActiveStorageBlurhash.renderAndLoad(target);
          break;
      }
    });
  }),
  renderAndLoad(wrapper) {
    const image = wrapper.querySelector("img");

    // the image might already be completely loaded. In this case we need to do nothing
    if (image.complete) return;

    // if the image comes in with empty dimensions, we can't assign canvas data
    if (image.width === 0 || image.height === 0) return;

    const width = image.width;
    const height = image.height;

    const canvas = wrapper.querySelector("canvas");

    canvas.width = width;
    canvas.height = height;

    const pixels = decode(wrapper.dataset.blurhash, width, height);
    const ctx = canvas.getContext("2d");
    const imageData = ctx.createImageData(width, height);
    imageData.data.set(pixels);
    ctx.putImageData(imageData, 0, 0);

    const swap = () => {
      canvas.style.opacity = "0";
    };

    if (image.complete) {
      // the image might already have been loaded
      swap();
    } else {
      // else we need to wait for it to load
      image.onload = swap;
    }
  },
};

document.addEventListener("turbo:load", () => {
  document.querySelectorAll("div[data-blurhash]").forEach((wrapper) => {
    window.ActiveStorageBlurhash.renderAndLoad(wrapper);
  });

  window.ActiveStorageBlurhash.observer.observe(document.body, {
    subtree: true,
    childList: true,
    attributes: true,
    attributeFilter: ["data-blurhash"],
  });
});
