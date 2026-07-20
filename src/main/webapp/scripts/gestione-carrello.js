$(document).ready(function() {
    $('.prodotto-quantita').on('input', function() {
        var quantita = $(this).val();
        var idProdotto = $(this).data('prodotto-id');
        var tr = $(this).closest('article');
        var errorText = tr.find('.error-text');
        errorText.text('');

        if (quantita < 1 || quantita > 99) {
            errorText.text('la quantità deve essere maggiore di 1 e minore di 99.');
            return;
        }

        $.ajax({
            url : 'update-quantita',
            type : 'POST',
            dataType : 'json',
            contentType : 'application/json',
            data : JSON.stringify({
                quantita : quantita,
                idProdotto : idProdotto
            }),
            success : function(response) {
                if (response.success) {
                    tr.find('.prodotto-quantita').val(quantita);
                    window.location.href = 'Cart';
                } else {
                    errorText.text(response.message);
                }
            },
            error : function() {
                errorText.text('An error occurred updating the quantita.');
            }
        });
    });
});