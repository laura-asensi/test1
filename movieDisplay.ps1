Import-Module .\classMovie.ps1
Import-Module .\API-Call.ps1
Add-Type -AssemblyName System.Windows.Forms
class MoviesForm {

    #Inicio la variable acá así todos los métodos usan la misma
    [system.Windows.Forms.Form]$Form = $null

    #Constructor vacío por default
    MoviesForm(){
        #Datos sobre la ventana, tamaño y el nombre que aparece
        $this.Form = New-Object system.Windows.Forms.Form
        $this.Form.Height = 750
        $this.Form.Width = 1000
        $this.Form.Text = "MovieSearch"
        #Sin esto no se puede scrollear
        $this.Form.AutoScroll = $true
    
    }

    
    
    #Le pasas una posicion X, una posicion Y, y un Texto y crea una Label
    [System.Windows.Forms.Label] AddLabel ([int]$X,[int]$Y,[int]$Height,[string]$text,[bool]$hidden) {
        #La fuente que usa el texto, creo que igual no está funcionando
        $font = New-Object System.Drawing.Font("Roboto",10)  
        #Crear nueva Label
        $Label = New-Object System.Windows.Forms.Label
        $Label.Height = 50
        $Label.Text = $text
        $Label.Font = $font
        $Label.Top = $Y +20
        $Label.Left = $X
        $Label.Width = 500
        $Label.Height = $Height
        $Label.Visible = !$hidden
        return $Label
    }

    [System.Windows.Forms.Button] AddButton ($movie,$positionY){
        $buttonMovie = New-Object System.Windows.Forms.Button
        #$buttonMovie.Text = "JP BUTTON"
        $buttonMovie.Name = $movie.urlToWatch
        $buttonMovie.Height = 200
        $buttonMovie.Width = 150
        if(Test-Path(".\Posters\"+$movie.id+".jpg")){
            $buttonMovie.Image = [System.Drawing.Image]::FromFile(".\Posters\"+$movie.id+".jpg")
        } else {
            $buttonMovie.Image = [System.Drawing.Image]::FromFile(".\Posters\default.jpg")
        }
        $buttonMovie.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
        $buttonMovie.Add_Click({
            Start-Process $this.Name
        })
        $buttonMovie.Location = New-Object System.Drawing.Point(10,($positionY))
        return $buttonMovie
    }


    #Le pasas una lista/array y la convierte en Labels(etiquetas de texto) 
    [void] AddMovie([Object[]]$movies) {
        
        $positionY = 10
        $positionX = 200
        foreach ($movie in $movies) {
            $buttonMovie = $this.AddButton($movie,$positionY)
            $this.Form.Controls.Add($buttonMovie)


            $lblYear = $this.AddLabel(($positionX+300), $positionY,20, $movie.releaseDate, $false)
            #Después de crear cada Label lo añadimos al Form con el siguiente llamado
            $this.Form.Controls.Add($lblYear)

            $lblTitle = $this.AddLabel($positionX,$positionY,20,$movie.title, $false)
            $this.Form.Controls.Add($lblTitle)

            $lblDescription = $this.AddLabel($positionX, ($positionY+30),100, $movie.description, $false)
            $this.Form.Controls.Add($lblDescription)

            $lblUrlToWatch = $this.AddLabel($positionX+500, ($positionY+30),0, $movie.UrltoWatch, $true)
            $this.Form.Controls.Add($lblUrlToWatch)
            

            #sumamos la posicionY para que el proximo esté más abajo
            $positionY += 250

        }
    }
    
    #Llamar a este metodo para mostrar la ventana
    Show(){
        $this.Form.ShowDialog()
    }
}

