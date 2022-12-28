namespace OtelOtomasyonuDBProje
{
    partial class PersonelForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(PersonelForm));
            this.lblBBaslik = new System.Windows.Forms.Label();
            this.Panel = new System.Windows.Forms.Panel();
            this.btnPersonel = new System.Windows.Forms.Button();
            this.btnMusteri = new System.Windows.Forms.Button();
            this.btnOdaRezervasyon = new System.Windows.Forms.Button();
            this.btnOtelYonetici = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.dataGridView2 = new System.Windows.Forms.DataGridView();
            this.label1 = new System.Windows.Forms.Label();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.btnListeleHizmetli = new System.Windows.Forms.Button();
            this.btnListeleDanisman = new System.Windows.Forms.Button();
            this.Panel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // lblBBaslik
            // 
            this.lblBBaslik.AutoSize = true;
            this.lblBBaslik.Font = new System.Drawing.Font("Consolas", 18F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.lblBBaslik.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.lblBBaslik.Location = new System.Drawing.Point(286, 12);
            this.lblBBaslik.Name = "lblBBaslik";
            this.lblBBaslik.Size = new System.Drawing.Size(303, 36);
            this.lblBBaslik.TabIndex = 42;
            this.lblBBaslik.Text = "Personel Bilgileri";
            // 
            // Panel
            // 
            this.Panel.BackColor = System.Drawing.Color.AliceBlue;
            this.Panel.Controls.Add(this.btnListeleDanisman);
            this.Panel.Controls.Add(this.btnListeleHizmetli);
            this.Panel.Controls.Add(this.label1);
            this.Panel.Controls.Add(this.dataGridView1);
            this.Panel.Controls.Add(this.label2);
            this.Panel.Controls.Add(this.dataGridView2);
            this.Panel.Font = new System.Drawing.Font("Consolas", 13.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.Panel.Location = new System.Drawing.Point(272, 51);
            this.Panel.Name = "Panel";
            this.Panel.Size = new System.Drawing.Size(1125, 671);
            this.Panel.TabIndex = 37;
            // 
            // btnPersonel
            // 
            this.btnPersonel.BackColor = System.Drawing.Color.LightSteelBlue;
            this.btnPersonel.ForeColor = System.Drawing.Color.AliceBlue;
            this.btnPersonel.Location = new System.Drawing.Point(26, 350);
            this.btnPersonel.Margin = new System.Windows.Forms.Padding(4);
            this.btnPersonel.Name = "btnPersonel";
            this.btnPersonel.Size = new System.Drawing.Size(228, 55);
            this.btnPersonel.TabIndex = 46;
            this.btnPersonel.Text = "Personel Bilgileri";
            this.btnPersonel.UseVisualStyleBackColor = false;
            this.btnPersonel.Click += new System.EventHandler(this.btnPersonel_Click);
            // 
            // btnMusteri
            // 
            this.btnMusteri.BackColor = System.Drawing.Color.LightSteelBlue;
            this.btnMusteri.ForeColor = System.Drawing.Color.AliceBlue;
            this.btnMusteri.Location = new System.Drawing.Point(26, 287);
            this.btnMusteri.Margin = new System.Windows.Forms.Padding(4);
            this.btnMusteri.Name = "btnMusteri";
            this.btnMusteri.Size = new System.Drawing.Size(228, 55);
            this.btnMusteri.TabIndex = 45;
            this.btnMusteri.Text = "Müşteri Bilgileri";
            this.btnMusteri.UseVisualStyleBackColor = false;
            this.btnMusteri.Click += new System.EventHandler(this.btnMusteri_Click);
            // 
            // btnOdaRezervasyon
            // 
            this.btnOdaRezervasyon.BackColor = System.Drawing.Color.LightSteelBlue;
            this.btnOdaRezervasyon.ForeColor = System.Drawing.Color.AliceBlue;
            this.btnOdaRezervasyon.Location = new System.Drawing.Point(26, 224);
            this.btnOdaRezervasyon.Margin = new System.Windows.Forms.Padding(4);
            this.btnOdaRezervasyon.Name = "btnOdaRezervasyon";
            this.btnOdaRezervasyon.Size = new System.Drawing.Size(228, 55);
            this.btnOdaRezervasyon.TabIndex = 43;
            this.btnOdaRezervasyon.Text = "Oda/Rezervasyon Bilgileri";
            this.btnOdaRezervasyon.UseVisualStyleBackColor = false;
            this.btnOdaRezervasyon.Click += new System.EventHandler(this.btnOdaRezervasyon_Click);
            // 
            // btnOtelYonetici
            // 
            this.btnOtelYonetici.BackColor = System.Drawing.Color.LightSteelBlue;
            this.btnOtelYonetici.ForeColor = System.Drawing.Color.AliceBlue;
            this.btnOtelYonetici.Location = new System.Drawing.Point(26, 413);
            this.btnOtelYonetici.Margin = new System.Windows.Forms.Padding(4);
            this.btnOtelYonetici.Name = "btnOtelYonetici";
            this.btnOtelYonetici.Size = new System.Drawing.Size(228, 55);
            this.btnOtelYonetici.TabIndex = 44;
            this.btnOtelYonetici.Text = "Otel/Yönetici Bilgileri";
            this.btnOtelYonetici.UseVisualStyleBackColor = false;
            this.btnOtelYonetici.Click += new System.EventHandler(this.btnOtelYonetici_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.label2.Location = new System.Drawing.Point(31, 58);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(208, 23);
            this.label2.TabIndex = 84;
            this.label2.Text = "Hizmetli Bilgileri";
            // 
            // dataGridView2
            // 
            this.dataGridView2.BackgroundColor = System.Drawing.SystemColors.Control;
            this.dataGridView2.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView2.Location = new System.Drawing.Point(25, 84);
            this.dataGridView2.Name = "dataGridView2";
            this.dataGridView2.RowHeadersWidth = 51;
            this.dataGridView2.RowTemplate.Height = 24;
            this.dataGridView2.Size = new System.Drawing.Size(784, 215);
            this.dataGridView2.TabIndex = 83;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.label1.Location = new System.Drawing.Point(31, 362);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(208, 23);
            this.label1.TabIndex = 86;
            this.label1.Text = "Danışman Bilgileri";
            // 
            // dataGridView1
            // 
            this.dataGridView1.BackgroundColor = System.Drawing.SystemColors.Control;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(25, 399);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.RowHeadersWidth = 51;
            this.dataGridView1.RowTemplate.Height = 24;
            this.dataGridView1.Size = new System.Drawing.Size(784, 215);
            this.dataGridView1.TabIndex = 85;
            // 
            // btnListeleHizmetli
            // 
            this.btnListeleHizmetli.BackColor = System.Drawing.Color.AliceBlue;
            this.btnListeleHizmetli.Font = new System.Drawing.Font("Consolas", 10.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.btnListeleHizmetli.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.btnListeleHizmetli.Location = new System.Drawing.Point(836, 141);
            this.btnListeleHizmetli.Margin = new System.Windows.Forms.Padding(4);
            this.btnListeleHizmetli.Name = "btnListeleHizmetli";
            this.btnListeleHizmetli.Size = new System.Drawing.Size(192, 39);
            this.btnListeleHizmetli.TabIndex = 98;
            this.btnListeleHizmetli.Text = "Hizmetli Listele";
            this.btnListeleHizmetli.UseVisualStyleBackColor = false;
            // 
            // btnListeleDanisman
            // 
            this.btnListeleDanisman.BackColor = System.Drawing.Color.AliceBlue;
            this.btnListeleDanisman.Font = new System.Drawing.Font("Consolas", 10.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.btnListeleDanisman.ForeColor = System.Drawing.SystemColors.ControlDarkDark;
            this.btnListeleDanisman.Location = new System.Drawing.Point(836, 486);
            this.btnListeleDanisman.Margin = new System.Windows.Forms.Padding(4);
            this.btnListeleDanisman.Name = "btnListeleDanisman";
            this.btnListeleDanisman.Size = new System.Drawing.Size(192, 39);
            this.btnListeleDanisman.TabIndex = 99;
            this.btnListeleDanisman.Text = "Danışman Listele";
            this.btnListeleDanisman.UseVisualStyleBackColor = false;
            // 
            // PersonelForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(11F, 23F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.LightSteelBlue;
            this.ClientSize = new System.Drawing.Size(1397, 724);
            this.Controls.Add(this.btnPersonel);
            this.Controls.Add(this.btnMusteri);
            this.Controls.Add(this.btnOdaRezervasyon);
            this.Controls.Add(this.btnOtelYonetici);
            this.Controls.Add(this.lblBBaslik);
            this.Controls.Add(this.Panel);
            this.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(162)));
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(4);
            this.MaximizeBox = false;
            this.Name = "PersonelForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Postgre Otel";
            this.Load += new System.EventHandler(this.PersonelForm_Load);
            this.Panel.ResumeLayout(false);
            this.Panel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblBBaslik;
        private System.Windows.Forms.Panel Panel;
        private System.Windows.Forms.Button btnPersonel;
        private System.Windows.Forms.Button btnMusteri;
        private System.Windows.Forms.Button btnOdaRezervasyon;
        private System.Windows.Forms.Button btnOtelYonetici;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.DataGridView dataGridView2;
        private System.Windows.Forms.Button btnListeleDanisman;
        private System.Windows.Forms.Button btnListeleHizmetli;
    }
}