import { decode } from "blurhash";

const MARKER_PREFIX = "active-storage-blurhash-";

window.ActiveStorageBlurhash = {
  // How many painted images a tab remembers. Without a ceiling the markers
  // outlive every page they were painted on, until the visitor's
  // sessionStorage quota is full.
  maxMarkers: 100,
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

    window.ActiveStorageBlurhash.markPainted(wrapper.dataset.blurhash);

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
  markers() {
    return Object.entries(sessionStorage).filter(([key]) =>
      key.startsWith(MARKER_PREFIX),
    );
  },
  markPainted(blurhash) {
    // A visitor whose storage is full or switched off must still see the
    // image lose its blur, so nothing in here may throw.
    try {
      const { markers, maxMarkers } = window.ActiveStorageBlurhash;

      // The oldest markers go first. A full picture stored by an earlier
      // version has no timestamp, so it goes before any of them.
      const kept = markers()
        .filter(([_key, paintedAt]) => Number.isFinite(Number(paintedAt)))
        .sort(([_a, first], [_b, second]) => Number(second) - Number(first))
        .slice(0, maxMarkers - 1)
        .map(([key]) => key);

      markers().forEach(([key]) => {
        if (!kept.includes(key)) sessionStorage.removeItem(key);
      });

      sessionStorage.setItem(MARKER_PREFIX + blurhash, Date.now());
    } catch {
      // the image still loads without the marker
    }
  },
  restoreCanvases() {
    let marked;
    try {
      marked = window.ActiveStorageBlurhash.markers();
    } catch {
      // storage is switched off, so no image was ever marked
      return;
    }

    marked.forEach(([key, _paintedAt]) => {
      const blurhash = key.slice(MARKER_PREFIX.length);
      const targetElement = document.querySelector(
        `[data-blurhash="${blurhash}"]`,
      );

      if (targetElement) {
        // The cached copy of the page has to show the blur again, or a
        // visitor coming back sees a bare box while the image reloads.
        const canvas = targetElement.querySelector("canvas");
        canvas.style.opacity = "100%";

        sessionStorage.removeItem(key);
      }
    });
  },
};

document.addEventListener("turbo:load", () => {
  document.querySelectorAll("div[data-blurhash]").forEach((wrapper) => {
    window.ActiveStorageBlurhash.renderAndLoad(wrapper);
  });

  window.ActiveStorageBlurhash.observer.disconnect();
  window.ActiveStorageBlurhash.observer.observe(document.body, {
    subtree: true,
    childList: true,
    attributes: true,
    attributeFilter: ["data-blurhash"],
  });
});

document.addEventListener(
  "turbo:before-cache",
  window.ActiveStorageBlurhash.restoreCanvases,
);
