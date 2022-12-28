using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace OtelOtomasyonuDBProje
{
    public partial class OtelYoneticiForm : Form
    {
        public OtelYoneticiForm()
        {
            InitializeComponent();
        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localhost; port=5432; Database=OtelOtomasyonudb; user ID=postgres; password=140402");
        private void btnOtelYonetici_Click(object sender, EventArgs e)
        {
            this.Refresh();
        }

        private void btnOdaRezervasyon_Click(object sender, EventArgs e)
        {
            OdaRezervasyonForm orf=new OdaRezervasyonForm();
            orf.Show();
            //this.Hide();
        }

        private void btnMusteri_Click(object sender, EventArgs e)
        {
            MusteriForm mf=new MusteriForm();
            mf.Show();
            //this.Hide();
        }

        private void btnPersonel_Click(object sender, EventArgs e)
        {
            PersonelForm pf = new PersonelForm();
            pf.Show();
            //this.Hide();
        }

        private void btnAdresEkle_Click(object sender, EventArgs e)
        {
            //baglanti.Open();
            //NpgsqlCommand komut1 = new NpgsqlCommand("insert into il(ilno,ilad) values (@p1,@p2)", baglanti);
            //NpgsqlCommand komut2 = new NpgsqlCommand("insert into ilce(ilceno,ilcead) values (@p3,@p4)", baglanti);
            //NpgsqlCommand komut3 = new NpgsqlCommand("insert into adres(adresno,ilno,ilceno) values (@p5,@p1,@p3)", baglanti);
            //komut1.Parameters.AddWithValue("@p1",int.Parse(txtilno.Text));
            //komut1.Parameters.AddWithValue("@p2",txtilad.Text);
            //komut2.Parameters.AddWithValue("@p3", txtilceno.Text);
            //komut2.Parameters.AddWithValue("@p4",txtilcead.Text);
            //komut3.Parameters.AddWithValue("@p5",);
            //komut1.ExecuteNonQuery();
            //komut2.ExecuteNonQuery();
            //komut3.ExecuteNonQuery();
            //baglanti.Close();

        }

        private void Panel_Paint(object sender, PaintEventArgs e)
        {

        }

        private void OtelYoneticiForm_Load(object sender, EventArgs e)
        {
            baglanti.Open();
            NpgsqlCommand komut4 = new NpgsqlCommand("Select * from OtelBilgiPanel",baglanti);
            NpgsqlDataAdapter da=new NpgsqlDataAdapter(komut4);
            DataSet dt=new DataSet();
            da.Fill(dt);
            dataGridView1.DataSource = dt.Tables[0];

            
            NpgsqlCommand komut5 = new NpgsqlCommand("Select * from yoneticiBilgiPanel", baglanti);
            NpgsqlDataAdapter da1 = new NpgsqlDataAdapter(komut5);
            DataSet dt1 = new DataSet();
            da1.Fill(dt1);
            dataGridView2.DataSource = dt1.Tables[0];

           
        }
    }
}
