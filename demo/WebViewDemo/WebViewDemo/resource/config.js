<script type="text/javascript">
function callJsAlert() {
   	alert('Objective-C call js to show alert');

    window.webkit.messageHandlers.AppModel.postMessage({body: 'call js alert in js'});
}

function callJsConfirm() {
    if (confirm('confirm', 'Objective-C call js to show confirm')) {
        document.getElementById('jsParamFuncSpan').innerHTML
        = 'true';
    } else {
        document.getElementById('jsParamFuncSpan').innerHTML
        = 'false';
    }

    window.webkit.messageHandlers.AppModel.postMessage({body: 'call js confirm in js'});
}

function callJsInput() {
    var response = prompt('Hello', 'Please input your name:');
    document.getElementById('jsParamFuncSpan').innerHTML = response;

    window.webkit.messageHandlers.AppModel.postMessage({body: response});
}

var jsParamFunc = function(argument) {
    document.getElementById('jsParamFuncSpan').innerHTML
    = argument['name'];
}
showAler();
</script>
