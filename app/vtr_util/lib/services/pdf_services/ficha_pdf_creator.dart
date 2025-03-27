import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:vtr_util/models/certificado.dart';
import 'package:vtr_util/services/pdf_services/base_pdf_creator.dart';

class FichaPdfCreator extends BasePdfCreator {
  final List<String> campos = [
    'Espaço Vazio',
    'Espaço Total',
    'Coef. +2%',
    'Coef. Seta',
    'Coef. -2%',
    'Pos. I. Nível',
    'Vol. Tub.',
    'Cap. Comp.',
    'Med. Comp.',
    'Esp. Pneus',
    'Pressão Pneu',
  ];
  final List<String> letras = ['', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  criaFicha(Certificado cert) async {
    final doc = createPdf();

    doc.pageSettings.size = PdfPageSize.a4;
    doc.pageSettings.orientation = PdfPageOrientation.landscape;

    //Create a PdfGrid
    PdfGrid grid = PdfGrid();

    grid.style =
        PdfGridStyle(font: PdfStandardFont(PdfFontFamily.timesRoman, 12));

    final format = PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.bottom);

    final formatTitulo = PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.bottom);

    final cellStyle = PdfGridCellStyle(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
      cellPadding: PdfPaddings(top: 2, bottom: 2),
      textBrush: PdfBrushes.gray,
      textPen: PdfPens.black,
    );

    final centraliza = PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle);
    final negritoCentralizado = PdfGridCellStyle(
      format: centraliza,
      textPen: PdfPens.black,
    );

    grid.columns.add(count: 11);
    final linha1 = grid.rows.add();
    linha1.cells[0].value =
        'INSTITUTO DE METROLOGIA DE SANTA CATARINA - IMETRO - S.C';
    linha1.cells[0].columnSpan = 11;
    linha1.cells[0].stringFormat = format;

    //var linha = grid.rows.add();
    // linha.cells[0].value =
    //     'VEÍCULO TANQUE - ESCRITÓRIO REGIONAL DE ITAJAÍ - S.C';
    // linha.cells[0].columnSpan = 9;
    // linha.cells[0].stringFormat = format;

    final linhaVeiculo = grid.rows.add();
    linhaVeiculo.cells[0].value = 'DADOS DO VEÍCULO';
    linhaVeiculo.cells[0].columnSpan = 11;
    linhaVeiculo.cells[0].stringFormat = formatTitulo;
    linhaVeiculo.cells[0].style = cellStyle;

    var linha = grid.rows.add();
    linha.cells[0].value = 'PLACA: ${cert.tanque.placa}';
    linha.cells[0].columnSpan = 4;
    linha.cells[4].value = 'MARCA: ${cert.marca}';
    linha.cells[4].columnSpan = 4;
    linha.cells[8].value = 'MODELO:';
    linha.cells[8].columnSpan = 3;

    linha = grid.rows.add();
    linha.cells[0].value = 'N° DO CHASSI: ${cert.chassi}';
    linha.cells[0].columnSpan = 6;
    linha.cells[6].value = 'ANO: ${cert.ano}';
    linha.cells[6].columnSpan = 5;

    linha = grid.rows.add();
    linha.cells[0].value = 'PROPRIETÁRIO: ${cert.proprietario}';
    linha.cells[0].columnSpan = 6;
    linha.cells[6].value = 'CPF/CNPJ: ${cert.cnpj}';
    linha.cells[6].columnSpan = 5;

    linha = grid.rows.add();
    linha.cells[0].value = 'ENDEREÇO:';
    linha.cells[0].columnSpan = 6;
    linha.cells[6].value = 'BAIRRO:';
    linha.cells[6].columnSpan = 5;

    linha = grid.rows.add();
    linha.cells[0].value = 'CIDADE: ${cert.municipio}';
    linha.cells[0].columnSpan = 4;
    linha.cells[4].value = 'ESTADO: ${cert.uf}';
    linha.cells[4].columnSpan = 4;
    linha.cells[8].value = 'CEP:';
    linha.cells[8].columnSpan = 3;

    final linhaTanque = grid.rows.add();
    linhaTanque.cells[0].value = 'DADOS DO TANQUE';
    linhaTanque.cells[0].columnSpan = 11;
    linhaTanque.cells[0].stringFormat = formatTitulo;
    linhaTanque.cells[0].style = cellStyle;

    linha = grid.rows.add();
    linha.cells[0].value = 'MARCA: ${cert.tanque.marcaTanque}';
    linha.cells[0].columnSpan = 4;
    linha.cells[4].value = 'N° DE SÉRIE: ${cert.numSerie}';
    linha.cells[4].columnSpan = 4;
    linha.cells[8].value = 'ANO:';
    linha.cells[8].columnSpan = 3;

    linha = grid.rows.add();
    linha.cells[0].value = 'N° INMETRO: ${cert.tanque.inmetro}';
    linha.cells[0].columnSpan = 6;
    linha.cells[6].value = 'CAPACIDADE: ${cert.tanque.capacidadeTotal}';
    linha.cells[6].columnSpan = 5;

    linha = grid.rows.add();

    for (int i = 1; i < 11; i++) {
      linha.cells[i].value = i.toString();
      linha.cells[i].style = negritoCentralizado;
    }

    for (var c in campos) {
      linha = grid.rows.add();
      linha.cells[0].value = c;
      if (c == 'Cap. Comp.') {
        for (int i = 0; i < cert.tanque.compartimentos.length; i++) {
          linha.cells[i + 1].value =
              '${cert.tanque.compartimentos[i].capacidade}';
          linha.cells[i + 1].style = negritoCentralizado;
        }
      }
    }

    linha = grid.rows.add();
    for (int i = 0; i < letras.length; i++) {
      linha.cells[i].value = letras[i];
    }

    linha = grid.rows.add();

    final stringFormat =
        PdfStringFormat(lineAlignment: PdfVerticalAlignment.bottom);
    final styleObs = PdfGridCellStyle(
        cellPadding: PdfPaddings(top: 16, bottom: 16), format: stringFormat);
    linha.cells[0].style = styleObs;

    linha.cells[0].value = 'Obs:';
    linha.cells[0].columnSpan = 9;
    linha.cells[0].style = styleObs;
    linha.cells[9].value = 'Data ____/____/20____';
    linha.cells[9].columnSpan = 2;
    linha.cells[9].style = styleObs;

    grid.draw(
      page: doc.pages.add(),
      bounds: const Rect.fromLTWH(0, 0, 0, 0),
    );

    await savePdf(doc);
  }
}
