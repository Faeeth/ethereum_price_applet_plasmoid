function getRate(callback) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'https://www.binance.com/api/v3/ticker/price?symbol=ETHEUR', true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var data = JSON.parse(xhr.responseText);
                var rate = data.price;
                callback(rate);
            } else {
                console.error('Request failed with status:', xhr.status);
            }
        }
    };
    xhr.send();
    return true;
}
