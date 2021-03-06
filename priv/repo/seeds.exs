# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Clio.Repo.insert!(%Clio.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Clio.Repo
alias Clio.Administrative.{Faculty}
alias Clio.Accounts.{User}

faculties =
  [
    %Faculty{name: "Биологически факултет", abbreviation: "БФ"},
    %Faculty{name: "Богословски факултет", abbreviation: "БогФ"},
    %Faculty{name: "Геолого-географски факултет", abbreviation: "ГГФ"},
    %Faculty{name: "Исторически факултет", abbreviation: "ИФ"},
    %Faculty{name: "Медицински факултет", abbreviation: "СФ"},
    %Faculty{name: "Стопански факултет", abbreviation: "СФ"},
    %Faculty{name: "Физически факултет", abbreviation: "ФзФ"},
    %Faculty{name: "Факултет по журналистика и масова комуникация", abbreviation: "ФЖМК"},
    %Faculty{name: "Факултет по класически и нови филологии", abbreviation: "ФКНФ"},
    %Faculty{name: "Факултет по математика и инфорамтика", abbreviation: "ФМИ"},
    %Faculty{name: "Факултет по начална и предучилиюна педагогика", abbreviation: "ФНПП"},
    %Faculty{name: "Факултет по педагогика", abbreviation: "ФСлФ"},
    %Faculty{name: "Факултет по славянски филологии", abbreviation: "ФСлФ"},
    %Faculty{name: "Факултет по химия и фармация", abbreviation: "ФХФ"},
    %Faculty{name: "Философски факултет", abbreviation: "ФФ"},
    %Faculty{name: "Юридически факултет", abbreviation: "ЮФ"},
  ]

faculties |> Enum.map(&Repo.insert!(&1))

users =
  [
    %User{contact_email: "admin@admin.bg",
          contact_number: "+359888123456",
          login_email: "adimn@uni-sofia.bg",
          is_active: true, is_supervisor: true, is_admin: true,
          id_number: "23646",
          first_name: "Admin",
          last_name: "Adminov",
          password:  "adminadmin",
          faculty_id: :rand.uniform(16)},

    %User{contact_email: "supervisor@supervisor.bg",
          contact_number: "+359888234567",
          login_email: "supervisor@uni-sofia.bg",
          id_number: "7873784167",
          first_name: "Supervisor",
          last_name: "Supervisor",
          password: "supervisor",
          faculty_id: :rand.uniform(16)},

    %User{contact_email: "user@user.bg",
          contact_number: "+359888345678",
          login_email: "user@uni-sofia.bg",
          is_active: true, is_supervisor: false, is_admin: false,
          id_number: "8737",
          first_name: "User",
          last_name: "Userov",
          password: "useruser",
          faculty_id: :rand.uniform(16)},
  ]

users |> Enum.map(&User.create_changeset(&1, %{})) |> Enum.map(&Repo.insert!/1)

for _ <- 0..1000 do
  %User{}
  |> User.create_changeset(Clio.Factory.params_for(:user))
  |> User.activate_changeset()
end
|> Enum.map(&(Task.async(fn -> Repo.insert!(&1, on_conflict: :nothing) end)))
|> Enum.map(&Task.await/1)
