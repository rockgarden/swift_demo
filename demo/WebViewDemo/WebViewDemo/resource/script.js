

    jQuery(document).ready(function ($) {

        $('#fullpage').fullpage({
            navigation: true,
            verticalCentered: false,
            scrollOverflow: true,
            anchors: ['firstPage', 'secondPage', 'thridPage', 'fourthPage', 'fifthPage', 'sixthPage', 'serventhPage']

        });
    });

function sendValue(option) {
    window.SwiftWebViewBridge.sendDataToSwift(
                                              {
                                              "name": option.title.text
                                              });
}

