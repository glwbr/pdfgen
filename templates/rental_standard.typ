#let conf(
  lessor: (
    name: str,
    cpf: str,
    rg: str,
    address: str,
    city: str,
    state: str,
    postal_code: str,
  ),
  lessee: (
    name: str,
    cpf: str,
    rg: str,
    address: str,
    city: str,
    state: str,
    postal_code: str,
  ),
  property: (
    address: str,
    city: str,
    state: str,
    postal_code: str,
    description: str,
  ),
  financial: (
    monthly_rent: str,
    due_date: int,
    security_deposit: str,
  ),
  lease: (
    duration: str,
    start_date: datetime,
    end_date: datetime,
    contract_date: datetime,
  ),
  witnesses: (
    include_witnesses: bool,
    witness1: (
      name: str,
      cpf: str,
    ),
    witness2: (
      name: str,
      cpf: str,
    ),
  ),
  custom_clauses: (),
  excluded_clauses: (),
  authors: (),
  abstract: [],
  doc,
) = {

  // Document setup
  set document(title: "Contrato de Locação Residencial")
  set page(
    paper: "a4",
    margin: (top: 2cm, bottom: 2cm, left: 2.5cm, right: 2.5cm),
    numbering: "1",
    number-align: center,
  )

  // Typography settings
  set text(
    font: "Libertinus Serif",
    size: 12pt,
    lang: "pt",
    region: "BR",
  )

  set par(
    justify: true,
    leading: 0.7em,
    first-line-indent: 1.5em,
  )

  // Helper function to check if clause should be shown
  let should_show_clause(clause_name) = {
    not excluded_clauses.contains(clause_name)
  }

  let clause(title, content) = {
    if title != "" {
      block(breakable: false)[
        #v(1.2em)
        #heading(level: 2)[#title]
        #set enum(
          numbering: "a.",
          tight: true,
          indent: 1.5em,
          spacing: auto
        )
        #content
      ]
    }
  }

  // Heading styles
  show heading.where(level: 1): it => [
    #set align(center)
    #set text(size: 16pt, weight: "bold")
    #block(above: 1em, below: 2em)[#upper(it.body)]
  ]

  show heading.where(level: 2): it => [
    #set text(size: 14pt, weight: "semibold")
    #block(above: 1.2em, below: 0.8em)[#it.body]
  ]

  // Custom styling for signature blocks
  let signature_block(name, doc) = {
    set align(center)
    block(
      width: 8cm,
      above: 1.5em,
      below: 0.5em,
      stroke: (top: 0.5pt),
      inset: (top: 0.8em),
    )[#text(size: 9pt, weight: "semibold")[#name] \ #text(size: 8pt)[#doc]]
  }

  // Document content
  heading(level: 1)[Contrato de Locação Residencial]

  block(par(first-line-indent: 0em)[*LOCADOR:* #lessor.name, brasileiro(a), portador(a) do CPF nº #lessor.cpf e RG nº #lessor.rg, residente e domiciliado(a) na #lessor.address, #lessor.city/#lessor.state, CEP #lessor.postal_code.])

  v(1em)

  block(par(first-line-indent: 0em)[*LOCATÁRIO:* #lessee.name, brasileiro(a), portador(a) do CPF nº #lessee.cpf e RG nº #lessee.rg, residente e domiciliado(a) na #lessee.address, #lessee.city/#lessee.state, CEP #lessee.postal_code.])

  v(1em)

  [As partes acima qualificadas têm entre si justo e acertado o presente #emph[Contrato de Locação Residencial], que se regerá pelas cláusulas e condições seguintes:]

  // Standard clauses with conditional rendering
  if should_show_clause("objeto") {
    clause[CLÁUSULA 1ª - DO OBJETO][O LOCADOR dá em locação ao LOCATÁRIO, que aceita, o imóvel situado na #property.address, #property.city/#property.state, CEP #property.postal_code, assim descrito: #property.description.]
  }

  if should_show_clause("finalidade") {
    clause[CLÁUSULA 2ª - DA FINALIDADE][O imóvel destina-se exclusivamente ao uso residencial do LOCATÁRIO e sua família, sendo vedada a cessão ou sublocação, total ou parcial, sem prévia e expressa concordância do LOCADOR.]
  }

  if should_show_clause("prazo") {
    clause[CLÁUSULA 3ª - DO PRAZO][O prazo de locação é de #lease.duration, com início em #lease.start_date e término em #lease.end_date, após o que o LOCATÁRIO deverá desocupar o imóvel independentemente de notificação ou interpelação judicial ou extrajudicial.]
  }

  if should_show_clause("aluguel") {
    clause[CLÁUSULA 4ª - DO ALUGUEL][O aluguel mensal é de R\$ #financial.monthly_rent, devendo ser pago até o dia #financial.due_date de cada mês, mediante depósito na conta bancária do LOCADOR ou conforme por ele indicado.

    #par(hanging-indent: 2em)[§ 1º - O atraso no pagamento do aluguel sujeitará o LOCATÁRIO ao pagamento de multa de 10% (dez por cento) sobre o valor em atraso, além de juros de mora de 1% (um por cento) ao mês e correção monetária.]

    #par(hanging-indent: 2em)[§ 2º - O não pagamento do aluguel por 3 (três) meses consecutivos ou 6 (seis) meses alternados autorizará o LOCADOR a promover ação de despejo por falta de pagamento.]]
  }

  if should_show_clause("deposito") {
    clause[CLÁUSULA 5ª - DO DEPÓSITO CAUÇÃO][O LOCATÁRIO depositou, a título de caução, a importância de R\$ #financial.security_deposit, que será devolvida ao final do contrato, descontadas as despesas com eventuais reparos necessários e débitos pendentes.]
  }

  if should_show_clause("obrigacoes_locatario") {
    clause[CLÁUSULA 6ª - DAS OBRIGAÇÕES DO LOCATÁRIO][O LOCATÁRIO obriga-se a:
    #enum(
      [Pagar pontualmente o aluguel e demais encargos;],
      [Servir-se do imóvel para o uso convencionado, com o cuidado de bom pai de família;],
      [Restituir o imóvel, finda a locação, no estado em que o recebeu, salvo deteriorações decorrentes do uso normal;],
      [Não sublocar, total ou parcialmente, nem ceder ou emprestar o imóvel;],
      [Não fazer obras ou modificações no imóvel sem prévia autorização por escrito do LOCADOR.]
    )]
  }

  if should_show_clause("obrigacoes_locador") {
    clause[CLÁUSULA 7ª - DAS OBRIGAÇÕES DO LOCADOR][São obrigações do LOCADOR:
    #enum(
      [Entregar o imóvel em perfeitas condições de uso;],
      [Garantir ao LOCATÁRIO o uso pacífico do imóvel;],
      [Realizar os reparos necessários por desgaste natural ou vício da construção;],
      [Pagar os impostos e taxas que incidam sobre o imóvel.]
    )]
  }

  if should_show_clause("rescisao") {
    clause[CLÁUSULA 8ª - DA RESCISÃO][O presente contrato poderá ser rescindido por infração de qualquer de suas cláusulas, independentemente de notificação judicial, ficando a parte infratora sujeita ao pagamento de multa equivalente a 3 (três) alugueres vigentes.]
  }

  // Insert custom clauses
  for clause_data in custom_clauses {
    clause[#clause_data.title][#clause_data.content]
  }

  if should_show_clause("foro") {
    clause[CLÁUSULA 9ª - DO FORO][As partes elegem o foro da Comarca de #property.city/#property.state para dirimir quaisquer questões oriundas do presente contrato.]
  }

  v(1.5em)

  [E por estarem justas e contratadas, as partes assinam o presente instrumento em 2 (duas) vias de igual teor e forma#if witnesses.include_witnesses [, na presença de 2 (duas) testemunhas].]

  v(1fr)

  align(center)[#property.city/#property.state, #lease.contract_date]

  v(2em)

  grid(
    columns: (1fr, 1fr),
    column-gutter: 2em,
    signature_block("LOCADOR", lessor.name + " - CPF: " + lessor.cpf),
    signature_block("LOCATÁRIO", lessee.name + " - CPF: " + lessee.cpf),
  )

  // Witnesses section - fixed condition
  if witnesses.include_witnesses and witnesses.witness1.name != "" {
    v(2em)
    align(center)[*TESTEMUNHAS:*]

    v(1.5em)

    grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      signature_block("1ª TESTEMUNHA", witnesses.witness1.name + " - CPF: " + witnesses.witness1.cpf),
      if witnesses.witness2.name != "" {
        signature_block("2ª TESTEMUNHA", witnesses.witness2.name + " - CPF: " + witnesses.witness2.cpf)
      }
    )
  }
}
