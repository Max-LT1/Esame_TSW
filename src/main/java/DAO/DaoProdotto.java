package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.sql.DataSource;

import model.Prodotto;

public class DaoProdotto {
    private DataSource dataSource;
    public DaoProdotto() {}

    public DaoProdotto(DataSource dataSource) {
        this.dataSource = dataSource;
    }
    //creare un prodotto
    public void createProdotto(Prodotto prodotto) throws SQLException {
        String query = "INSERT INTO prodotto (ID_Prodotto, nome_Prodotto, prezzo, descrizione, categoria, tipo, iva_p, materiale, path_immagine, data_inserto, sconto) " +
                "VALUES (? ? ? ? ? ? ? ? ? ?)";
        try(Connection connection = dataSource.getConnection(); PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, prodotto.getIdProdotto());
            statement.setString(2, prodotto.getNomeProdotto());
            statement.setBigDecimal(3, prodotto.getPrezzo());
            statement.setString(4, prodotto.getDescrizione());
            statement.setString(5, prodotto.getCategoria());
            statement.setString(6, prodotto.getTipo());
            statement.setDouble(7, prodotto.getIdProdotto());
            statement .setString(8, prodotto.getMateriale());
            statement.setString(9, prodotto.getPath_immagine());
            statement.setDate(10, (Date) prodotto.getDataInserimento());
            statement.setInt(11, prodotto.getSconto());
            statement.execute();
        }
        catch (SQLException ex) {
            Logger.getLogger(DaoProdotto.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    //Metodo per cancellare un prodotto
    public void deleteProdotto(int id) throws SQLException {
        String query = "DELETE FROM prodotto WHERE ID_prodotto = ?";
        try(Connection connection = dataSource.getConnection(); PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, id);
            statement.execute();
        }
        catch (SQLException ex) {
            Logger.getLogger(DaoProdotto.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    //Metodo per ottenere una lista completa di prodotti con la data di inserimento per gli Admin
    public List<Prodotto> listaProdottiAdmn() throws SQLException {
        String query = "SELECT * FROM prodotto";
        try(Connection connection = dataSource.getConnection();
            PreparedStatement statement = connection.prepareStatement(query);
            ResultSet resultSet = statement.executeQuery()) {
            List<Prodotto> prodotti = new ArrayList<>();
            while (resultSet.next()) {
                Prodotto prodotto = new Prodotto();
                prodotto.setIdProdotto(resultSet.getInt("ID_prodotto"));
                prodotto.setNomeProdotto(resultSet.getString("nome_prodotto"));
                prodotto.setPrezzo(resultSet.getBigDecimal("prezzo"));
                prodotto.setCategoria(resultSet.getString("categoria"));
                prodotto.setTipo(resultSet.getString("tipo"));
                prodotto.setMateriale(resultSet.getString("materiale"));
                prodotto.setIva(resultSet.getInt("iva_p"));
                prodotto.setDescrizione(resultSet.getString("descrizione"));
                prodotto.setPath_immagine(resultSet.getString("path_immagine"));
                prodotto.setDataInserimento(resultSet.getDate("data_Inserimento"));
                prodotto.setSconto(resultSet.getInt("sconto"));
                prodotti.add(prodotto);
            }
            return prodotti;
        }
    }
    public List<Prodotto> prodottiPerTipo(String tipo) throws SQLException {
        String query = "SELECT * FROM prodotto WHERE tipo = ?";
        try(Connection connection = dataSource.getConnection();
            PreparedStatement statement = connection.prepareStatement(query)){
            List<Prodotto> prodotti = new ArrayList<>();
            statement.setString(1, tipo);
            ResultSet resultSet = statement.executeQuery();
            while(resultSet.next()) {
                Prodotto prodotto = new Prodotto();
                prodotto.setIdProdotto(resultSet.getInt("ID_prodotto"));
                prodotto.setNomeProdotto(resultSet.getString("nome_prodotto"));
                prodotto.setPrezzo(resultSet.getBigDecimal("prezzo"));
                prodotto.setCategoria(resultSet.getString("categoria"));
                prodotto.setTipo(resultSet.getString("tipo"));
                prodotto.setMateriale(resultSet.getString("materiale"));
                prodotto.setIva(resultSet.getInt("iva_p"));
                prodotto.setDescrizione(resultSet.getString("descrizione"));
                prodotto.setPath_immagine(resultSet.getString("path_immagine"));
                prodotto.setDataInserimento(resultSet.getDate("data_Inserimento"));
                prodotto.setSconto(resultSet.getInt("sconto"));
                prodotti.add(prodotto);
            }
            return prodotti;
        }
    }
    public List<Prodotto> prodottiPerCategoria(String Categoria) throws SQLException {
        String query = "SELECT * FROM prodotto WHERE categoria = ?";
        try(Connection connection = dataSource.getConnection();
            PreparedStatement statement = connection.prepareStatement(query);){
            List<Prodotto> prodotti = new ArrayList<>();
            statement.setString(1, Categoria);
            ResultSet resultSet = statement.executeQuery();
            while(resultSet.next()) {
                Prodotto prodotto = new Prodotto();
                prodotto.setIdProdotto(resultSet.getInt("ID_prodotto"));
                prodotto.setNomeProdotto(resultSet.getString("nome_prodotto"));
                prodotto.setPrezzo(resultSet.getBigDecimal("prezzo"));
                prodotto.setCategoria(resultSet.getString("categoria"));
                prodotto.setTipo(resultSet.getString("tipo"));
                prodotto.setMateriale(resultSet.getString("materiale"));
                prodotto.setIva(resultSet.getInt("iva_p"));
                prodotto.setDescrizione(resultSet.getString("descrizione"));
                prodotto.setPath_immagine(resultSet.getString("path_immagine"));
                prodotto.setDataInserimento(resultSet.getDate("data_Inserimento"));
                prodotto.setSconto(resultSet.getInt("sconto"));
                prodotti.add(prodotto);
            }
            return prodotti;
        }
    }
    public Prodotto getProdottoById(int id) throws SQLException {
        String query = "SELECT * FROM prodotto WHERE id_prodotto = ?";
        try(Connection connection = dataSource.getConnection();){
            PreparedStatement statement = connection.prepareStatement(query);
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            Prodotto p = new Prodotto();
            if(resultSet.next()) {
                p.setIdProdotto(resultSet.getInt("id_prodotto"));
                p.setNomeProdotto(resultSet.getString("nome_prodotto"));
                p.setPrezzo(resultSet.getBigDecimal("prezzo"));
                p.setCategoria(resultSet.getString("categoria"));
                p.setTipo(resultSet.getString("tipo"));
                p.setMateriale(resultSet.getString("materiale"));
                p.setIva(resultSet.getInt("iva_p"));
                p.setDescrizione(resultSet.getString("descrizione"));
                p.setPath_immagine(resultSet.getString("path_immagine"));
                p.setDataInserimento(resultSet.getDate("Data_inserimento"));
                p.setSconto(resultSet.getInt("sconto"));
                return p;
            }
            //prodotto non trovato
            return null;
        }
    }
    public Prodotto getProdottoByNome(String nome) throws SQLException {
        String query = "SELECT * FROM prodotto WHERE nome_prodotto = ?";
        try(Connection connection = dataSource.getConnection();
        PreparedStatement statement = connection.prepareStatement(query);){
            statement.setString(1, nome);
            ResultSet resultSet = statement.executeQuery();
            Prodotto p = new Prodotto();
            if(resultSet.next()) {
                p.setIdProdotto(resultSet.getInt("id_prodotto"));
                p.setNomeProdotto(resultSet.getString("nome_prodotto"));
                p.setPrezzo(resultSet.getBigDecimal("prezzo"));
                p.setCategoria(resultSet.getString("categoria"));
                p.setTipo(resultSet.getString("tipo"));
                p.setMateriale(resultSet.getString("materiale"));
                p.setIva(resultSet.getInt("iva_p"));
                p.setDescrizione(resultSet.getString("descrizione"));
                p.setPath_immagine(resultSet.getString("path_immagine"));
                p.setDataInserimento(resultSet.getDate("Data_inserimento"));
                p.setSconto(resultSet.getInt("sconto"));
                return p;
            }
        }
        return null;
    }
    //prendere prodotti Per clienti
    public List<Prodotto> ListaProdotti() throws SQLException{
        String query = "SELECT * FROM prodotto";
        try(Connection connection = dataSource.getConnection();
        PreparedStatement statement = connection.prepareStatement(query);
        ResultSet resultSet = statement.executeQuery()){
            List<Prodotto> prodotti = new ArrayList<>();
            while(resultSet.next()){
                Prodotto prodotto = new Prodotto();
                prodotto.setIdProdotto(resultSet.getInt("ID_prodotto"));
                prodotto.setNomeProdotto(resultSet.getString("nome_prodotto"));
                prodotto.setPrezzo(resultSet.getBigDecimal("prezzo"));
                prodotto.setCategoria(resultSet.getString("categoria"));
                prodotto.setTipo(resultSet.getString("tipo"));
                prodotto.setMateriale(resultSet.getString("materiale"));
                prodotto.setIva(resultSet.getInt("iva_p"));
                prodotto.setDescrizione(resultSet.getString("descrizione"));
                prodotto.setPath_immagine(resultSet.getString("path_immagine"));
                prodotto.setSconto(resultSet.getInt("sconto"));
                prodotto.setDataInserimento(null);
                prodotti.add(prodotto);
            }
            return prodotti;
        }
    }

//Prende tutti i prodotti con uno sconto
public List<Prodotto> getAllSconto() throws SQLException{
        String query = "SELECT * FROM prodotto WHERE sconto != 0";
        try(Connection connection = dataSource.getConnection();
        PreparedStatement statement = connection.prepareStatement(query);
            ResultSet resultSet = statement.executeQuery();){
            List<Prodotto> prodotti = new ArrayList<>();
            while(resultSet.next()){
                Prodotto prodotto = new Prodotto();
                prodotto.setIdProdotto(resultSet.getInt("ID_prodotto"));
                prodotto.setNomeProdotto(resultSet.getString("nome_prodotto"));
                prodotto.setPrezzo(resultSet.getBigDecimal("prezzo"));
                prodotto.setCategoria(resultSet.getString("categoria"));
                prodotto.setTipo(resultSet.getString("tipo"));
                prodotto.setMateriale(resultSet.getString("materiale"));
                prodotto.setIva(resultSet.getInt("iva_p"));
                prodotto.setDescrizione(resultSet.getString("descrizione"));
                prodotto.setPath_immagine(resultSet.getString("path_immagine"));
                prodotto.setSconto(resultSet.getInt("sconto"));
                prodotto.setDataInserimento(null);
                prodotti.add(prodotto);
            }
            return prodotti;
        }
}
    //recupera tutti i prodotti con uno sconto uguale o superiore alla ricerca
    public List<Prodotto> getBySconto(int sconto) throws SQLException{
        String query = "SELECT * FROM prodotto WHERE sconto >= ?";
        try(Connection connection = dataSource.getConnection();
            PreparedStatement statement = connection.prepareStatement(query);){
            statement.setInt(1, sconto);
            ResultSet resultSet = statement.executeQuery();
            List<Prodotto> prodotti = new ArrayList<>();
            while(resultSet.next()){
                Prodotto prodotto = new Prodotto();
                prodotto.setIdProdotto(resultSet.getInt("ID_prodotto"));
                prodotto.setNomeProdotto(resultSet.getString("nome_prodotto"));
                prodotto.setPrezzo(resultSet.getBigDecimal("prezzo"));
                prodotto.setCategoria(resultSet.getString("categoria"));
                prodotto.setTipo(resultSet.getString("tipo"));
                prodotto.setMateriale(resultSet.getString("materiale"));
                prodotto.setIva(resultSet.getInt("iva_p"));
                prodotto.setDescrizione(resultSet.getString("descrizione"));
                prodotto.setPath_immagine(resultSet.getString("path_immagine"));
                prodotto.setSconto(resultSet.getInt("sconto"));
                prodotto.setDataInserimento(null);
                prodotti.add(prodotto);
            }
            return prodotti;
        }
    }

    public List<Prodotto> getLatestadds(){
        String query = "SELECT * FROM prodotto WHERE data_Inserimento >=NOW() - INTERVAL 4 MONTH";
        try(Connection connection = dataSource.getConnection();
            PreparedStatement statement = connection.prepareStatement(query);
            ResultSet resultSet = statement.executeQuery();){
            List<Prodotto> prodotti = new ArrayList<>();
            while(resultSet.next()){
                Prodotto prodotto = new Prodotto();
                prodotto.setIdProdotto(resultSet.getInt("ID_prodotto"));
                prodotto.setNomeProdotto(resultSet.getString("nome_prodotto"));
                prodotto.setPrezzo(resultSet.getBigDecimal("prezzo"));
                prodotto.setCategoria(resultSet.getString("categoria"));
                prodotto.setTipo(resultSet.getString("tipo"));
                prodotto.setMateriale(resultSet.getString("materiale"));
                prodotto.setIva(resultSet.getInt("iva_p"));
                prodotto.setDescrizione(resultSet.getString("descrizione"));
                prodotto.setPath_immagine(resultSet.getString("path_immagine"));
                prodotto.setSconto(resultSet.getInt("sconto"));
                prodotto.setDataInserimento(null);
                prodotti.add(prodotto);
            }
            return prodotti;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Prodotto p) throws SQLException {
        String query = "UPDATE prodotto SET ID_prodotto = ?, nome_prodotto = ?, prezzo = ?, descrizione = ?, categoria = ?, tipo = ?, iva_p = ?, materiale = ?, path_immagine = ?, data_Inserimento = ?, sconto = ? WHERE id_prodotto = ?";
        try(Connection connection = dataSource.getConnection();
        PreparedStatement statement = connection.prepareStatement(query);){
            statement.setInt(1, p.getIdProdotto());
            statement.setString(2, p.getNomeProdotto());
            statement.setBigDecimal(3, p.getPrezzo());
            statement.setString(4, p.getDescrizione());
            statement.setString(5, p.getCategoria());
            statement.setString(6, p.getTipo());
            statement.setDouble(7, p.getIva());
            statement.setString(8, p.getMateriale());
            statement.setString(9, p.getPath_immagine());
            statement.setDate(10, (Date) p.getDataInserimento());
            statement.setInt(11, p.getSconto());
        }
    }
}
