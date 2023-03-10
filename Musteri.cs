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
    public partial class MusteriForm : Form
    {
        public MusteriForm()
        {
            InitializeComponent();
        }
        NpgsqlConnection baglanti = new NpgsqlConnection("server=localhost; port=5432; Database=OtelOtomasyonudb; user ID=postgres; password=140402");
        private void Musteri_Load(object sender, EventArgs e)
        {
          
        }

        private void btnOdaRezervasyon_Click(object sender, EventArgs e)
        {
            OdaRezervasyonForm orf = new OdaRezervasyonForm();
            orf.Show();
            //this.Hide();
        }

        private void btnOtelYonetici_Click(object sender, EventArgs e)
        {
            OtelYoneticiForm oyf = new OtelYoneticiForm();
            oyf.Show();
            //this.Hide();
        }

        private void btnPersonel_Click(object sender, EventArgs e)
        {
            PersonelForm pf = new PersonelForm();
            pf.Show();
            //this.Hide();
        }

        private void btnMusteri_Click(object sender, EventArgs e)
        {
            this.Refresh();
        }
    }
}
