enum OperationType { turning, milling }

class BushSpecification {
  final String partNumber;
  final String od;
  final String odTolerance;
  final String idMin;
  final String idMax;
  final String idTolerance;
  final String lengthRange;
  final String b;
  final String c;
  final String f;
  final String g;
  final String h;
  final String j;
  final String l;
  final String r;
  final String lockScrew;

  const BushSpecification({
    required this.partNumber,
    required this.od,
    required this.odTolerance,
    required this.idMin,
    required this.idMax,
    required this.idTolerance,
    required this.lengthRange,
    required this.b,
    required this.c,
    required this.f,
    required this.g,
    required this.h,
    required this.j,
    required this.l,
    required this.r,
    required this.lockScrew,
  });
}

class BushSpecRepository {
  static List<BushSpecification> getAll() => [
        const BushSpecification(partNumber:'SF12-X', od:'3/16', odTolerance:'-.0000/-.0002', idMin:'0.0135', idMax:'0.1270', idTolerance:'+0.0001/+0.0004', lengthRange:'1/8–3/4', b:'R.02', c:'.010x45°', f:'5/16', g:'1/4', h:'1/8', j:'3/32', l:'55', r:'17/64', lockScrew:'LS-0'),
        const BushSpecification(partNumber:'SF16-X', od:'1/4', odTolerance:'-.0000/-.0002', idMin:'0.0980', idMax:'0.1995', idTolerance:'+0.0001/+0.0004', lengthRange:'1/4–1-3/4', b:'R.02', c:'.010x45°', f:'7/16', g:'1/4', h:'1/8', j:'9/64', l:'30', r:'23/64', lockScrew:'TW-2'),
        const BushSpecification(partNumber:'SF20-X', od:'5/16', odTolerance:'-.0000/-.0002', idMin:'0.1250', idMax:'0.2120', idTolerance:'+0.0001/+0.0005', lengthRange:'1/4–1-3/4', b:'R.02', c:'.015x45°', f:'35/64', g:'1/4', h:'1/8', j:'11/64', l:'65', r:'1/2', lockScrew:'LS-1'),
        const BushSpecification(partNumber:'SF24-X', od:'3/8', odTolerance:'-.0000/-.0002', idMin:'0.1875', idMax:'0.2745', idTolerance:'+0.0001/+0.0005', lengthRange:'1/4–1-3/4', b:'R.04', c:'.015x45°', f:'5/8', g:'1/4', h:'1/8', j:'15/64', l:'30', r:'29/64', lockScrew:'TW-2'),
        const BushSpecification(partNumber:'SF28-X', od:'7/16', odTolerance:'-.0000/-.0002', idMin:'0.1875', idMax:'0.3370', idTolerance:'+0.0001/+0.0005', lengthRange:'1/4–1-3/4', b:'R.04', c:'.015x45°', f:'5/8', g:'1/4', h:'1/8', j:'15/64', l:'30', r:'29/64', lockScrew:'TW-2'),
        const BushSpecification(partNumber:'SF32-X', od:'1/2', odTolerance:'-.0000/-.0002', idMin:'0.1875', idMax:'0.3995', idTolerance:'+0.0001/+0.0005', lengthRange:'1/4–2-1/8', b:'R.04', c:'.015x45°', f:'51/64', g:'1/4', h:'1/8', j:'19/64', l:'65', r:'5/8', lockScrew:'LS-1'),
        const BushSpecification(partNumber:'SF36-X', od:'9/16', odTolerance:'-.0000/-.0002', idMin:'0.1875', idMax:'0.4620', idTolerance:'+0.0001/+0.0005', lengthRange:'1/4–2-1/8', b:'R.04', c:'.015x45°', f:'7/8', g:'1/4', h:'1/8', j:'23/64', l:'65', r:'37/64', lockScrew:'TW-2'),
        const BushSpecification(partNumber:'SF40-X', od:'5/8', odTolerance:'-.0000/-.0002', idMin:'0.1875', idMax:'0.5245', idTolerance:'+0.0001/+0.0005', lengthRange:'1/4–2-1/8', b:'R.04', c:'.015x45°', f:'7/8', g:'1/4', h:'1/8', j:'23/64', l:'30', r:'37/64', lockScrew:'TW-2'),
        const BushSpecification(partNumber:'SF48-X', od:'3/4', odTolerance:'-.0000/-.0002', idMin:'0.1875', idMax:'0.6495', idTolerance:'+0.0001/+0.0005', lengthRange:'1/4–2-1/2', b:'R.04', c:'.015x45°', f:'1-3/64', g:'1/4', h:'1/8', j:'27/64', l:'50', r:'3/4', lockScrew:'LS-1'),
        const BushSpecification(partNumber:'SF56-X', od:'7/8', odTolerance:'-.0000/-.0002', idMin:'0.1875', idMax:'0.7740', idTolerance:'+0.0002/+0.0006', lengthRange:'1/4–2-1/2', b:'R.06', c:'.030x45°', f:'1-1/4', g:'3/8', h:'3/16', j:'31/64', l:'30', r:'53/64', lockScrew:'TW-7'),
        const BushSpecification(partNumber:'SF64-X', od:'1', odTolerance:'-.0000/-.0002', idMin:'0.1875', idMax:'0.7990', idTolerance:'+0.0002/+0.0006', lengthRange:'1/4–3', b:'R.06', c:'.030x45°', f:'1-27/64', g:'3/8', h:'3/16', j:'19/32', l:'35', r:'59/64', lockScrew:'LS-2'),
        const BushSpecification(partNumber:'SF80-X', od:'1-1/4', odTolerance:'-.0000/-.0003', idMin:'0.1875', idMax:'1.0400', idTolerance:'+0.0002/+0.0006', lengthRange:'1/4–3', b:'R.06', c:'.030x45°', f:'1-5/8', g:'3/8', h:'3/16', j:'43/64', l:'30', r:'1-1/64', lockScrew:'LS-2'),
        const BushSpecification(partNumber:'SF88-X', od:'1-3/8', odTolerance:'-.0000/-.0003', idMin:'0.1875', idMax:'1.1740', idTolerance:'+0.0002/+0.0006', lengthRange:'1/2–3', b:'R.06', c:'.030x45°', f:'1-51/64', g:'3/8', h:'3/16', j:'25/32', l:'30', r:'1-7/64', lockScrew:'LS-2'),
        const BushSpecification(partNumber:'SF96-X', od:'1-1/2', odTolerance:'-.0000/-.0003', idMin:'0.1875', idMax:'1.2990', idTolerance:'+0.0002/+0.0006', lengthRange:'3/4–3', b:'R.06', c:'.030x45°', f:'1-7/8', g:'3/8', h:'3/16', j:'51/64', l:'30', r:'1-9/64', lockScrew:'LS-2'),
        const BushSpecification(partNumber:'SF112-X', od:'1-3/4', odTolerance:'-.0000/-.0003', idMin:'0.1875', idMax:'1.5490', idTolerance:'+0.0003/+0.0007', lengthRange:'3/4–3', b:'R.10', c:'.040x45°', f:'2-19/64', g:'3/8', h:'3/16', j:'1', l:'30', r:'1-25/64', lockScrew:'LS-3'),
        const BushSpecification(partNumber:'SF120-X', od:'2', odTolerance:'-.0000/-.0004', idMin:'0.1875', idMax:'1.7990', idTolerance:'+0.0003/+0.0007', lengthRange:'3/4–3', b:'R.10', c:'.040x45°', f:'2-9/16', g:'3/8', h:'3/16', j:'1-1/8', l:'35', r:'1-33/64', lockScrew:'LS-3'),
        const BushSpecification(partNumber:'SF144-X', od:'2-1/4', odTolerance:'-.0000/-.0004', idMin:'0.1875', idMax:'2.0495', idTolerance:'+0.0003/+0.0007', lengthRange:'3/4–3', b:'R.10', c:'.040x45°', f:'2-51/64', g:'3/8', h:'3/16', j:'1-1/4', l:'25', r:'1-41/64', lockScrew:'LS-3'),
        const BushSpecification(partNumber:'SF160-X', od:'2-1/2', odTolerance:'-.0000/-.0005', idMin:'0.1875', idMax:'2.2990', idTolerance:'+0.0003/+0.0007', lengthRange:'3/4–5', b:'R.10', c:'.040x45°', f:'3-1/16', g:'3/8', h:'3/16', j:'1-3/8', l:'35', r:'1-49/64', lockScrew:'LS-3'),
      ];

  static BushSpecification? findByPartNumber(String pn) {
    try {
      return getAll().firstWhere((s) => s.partNumber == pn);
    } catch (_) {
      return getAll().first;
    }
  }
}

