package model;

import java.math.BigDecimal;
import java.util.Date;

public class Prodotto {
    private String descrizione;
    private int idProdotto;
    private double iva;
    private String nomeProdotto;
    private String path_immagine;
    private BigDecimal prezzo;
    private String materiale;
    private String categoria;
    private String tipo;
    private Date dataInserimento;
    private int sconto;

    public Prodotto(){}

    public Prodotto(String descrizione, int idProdotto, double iva, String nomeProdotto, String path_immagine, BigDecimal prezzo, String materiale, String categoria, String tipo, Date dataInserimento, int sconto) {
        this.descrizione = descrizione;
        this.idProdotto = idProdotto;
        this.iva = iva;
        this.nomeProdotto = nomeProdotto;
        this.path_immagine = path_immagine;
        this.prezzo = prezzo;
        this.materiale = materiale;
        this.categoria = categoria;
        this.tipo = tipo;
        this.dataInserimento = dataInserimento;
        this.sconto = sconto;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public int getIdProdotto() {
        return idProdotto;
    }

    public void setIdProdotto(int idProdotto) {
        this.idProdotto = idProdotto;
    }

    public double getIva() {
        return iva;
    }

    public void setIva(double iva) {
        this.iva = iva;
    }

    public String getNomeProdotto() {
        return nomeProdotto;
    }

    public void setNomeProdotto(String nomeProdotto) {
        this.nomeProdotto = nomeProdotto;
    }

    public String getPath_immagine() {
        return path_immagine;
    }

    public void setPath_immagine(String path_immagine) {
        this.path_immagine = path_immagine;
    }

    public BigDecimal getPrezzo() {
        return prezzo;
    }

    public void setPrezzo(BigDecimal prezzo) {
        this.prezzo = prezzo;
    }

    public String getMateriale() {
        return materiale;
    }

    public void setMateriale(String materiale) {
        this.materiale = materiale;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public void setDataInserimento(Date dataInserimento) {
        this.dataInserimento = dataInserimento;
    }
    public Date getDataInserimento() {
        return dataInserimento;
    }
    public int getSconto() {
        return sconto;
    }
    public void setSconto(int sconto){
        this.sconto = sconto;
    }
}
