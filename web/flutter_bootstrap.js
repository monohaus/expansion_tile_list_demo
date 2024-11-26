{{flutter_js}}

{{flutter_build_config}}


let viewIds = [];

function resetWebUI() {
    viewIds = [];
    /* grid.replaceChildren();
     remover.disabled = true;
     adder.disabled = false;*/

}

let flutterApp = new Promise((resolve, reject) => {
    const flutterViewWrapper = getFlutterViewWrapper();
    flutterViewWrapper.textContent = "Loading Entrypoint...";
    _flutter.loader.load({
        onEntrypointLoaded: async function (engineInitializer) {
            try {
                flutterViewWrapper.textContent = "Initializing Engine...";
                let app = await initApp(engineInitializer,
                    (engine) => {
                        flutterViewWrapper.textContent = "Running App..."
                    });
                resolve(app);
            } catch (e) {
                console.log('Error:', e);
                reject(e);
            }
        }
    });
});

async function initApp(engineInitializer, initCallback) {
    let engine = await engineInitializer.initializeEngine({
       // multiViewEnabled: true,
        //renderer: 'canvaskit',
    });
    if (typeof initCallback === 'function') {
        initCallback(engine);
    }
    let app = engine.runApp();
    console.log('Flutter engine loaded:', app);
    return app;
}

async function addView() {
    if (viewIds.length > 0) return;
    let viewId = (await flutterApp).addView({
        hostElement: getFlutterViewWrapper(),
        viewConstraints: { //412 914
            maxWidth: 600,
            maxHeight: 812,
            minWidth: 375,
            minHeight: 240,
        },
    });
    viewIds.push(viewId);
    console.log('Added view ID:', viewId);
    // Handle enabling/disabling the remove_last button
    //remover.disabled = viewIds.length == 0;
}

function getFlutterViewWrapper() {
    let flutterViewWrapper = document.getElementById('flutter-view-wrapper')
        || document.querySelector('.flutter-view-wrapper');
    if (flutterViewWrapper == null) {
        flutterViewWrapper = document.createElement('div');
        flutterViewWrapper.classList.add('flutter-view-wrapper');
        document.body.appendChild(flutterViewWrapper);
    }
    return flutterViewWrapper;
}

async function removeView() {
    let viewId = viewIds.pop();
    if (viewId == null) return;
    (await flutterApp).removeView(viewId);
    console.log('Removed view ID:', viewId);
    // Handle enabling/disabling the remove_last button
    //remover.disabled = viewIds.length == 0;
}