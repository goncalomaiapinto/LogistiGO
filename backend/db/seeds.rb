c1 = Company.create!(name: "Empresa XPTO")
c2 = Company.create!(name: "TransLogistics")

u1 = User.create!(name: "João", email: "joao@test.com", role: "admin", company: c1)
u2 = User.create!(name: "Maria", email: "maria@test.com", role: "user", company: c1)

Task.create!(title: "Entregar materiais", status: "pending", user: u2, company: c1)
Task.create!(title: "Levantar carga", status: "in_progress", user: u1, company: c2)