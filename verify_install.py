from processes.models import *

print('=== USUARIOS ===')
print(f'Total usuarios: {User.objects.count()}')
print(f'Admins: {User.objects.filter(role="ADMIN").count()}')
print(f'Gestores: {User.objects.filter(role="MANAGER").count()}')
print(f'Participantes: {User.objects.filter(role="PARTICIPANT").count()}')

print('\n=== USUARIOS DETALLE ===')
for u in User.objects.all().order_by('pk'):
    print(f'  ID={u.pk}, username={u.username}, role={u.role}')

print('\n=== DATOS CARGADOS ===')
print(f'SubProcessTemplates: {SubProcessTemplate.objects.count()}')
print(f'OperationTemplates: {OperationTemplate.objects.count()}')
print(f'StorageTypes: {StorageType.objects.count()}')
print(f'Carreras: {Career.objects.count()}')
print(f'Períodos: {AcademicPeriod.objects.count()}')

print('\n=== SubProcess Templates ===')
for spt in SubProcessTemplate.objects.all():
    print(f'  [{spt.pk}] {spt.name}')

print('\n=== Carreras ===')
for c in Career.objects.all():
    print(f'  [{c.pk}] {c.name}')

print('\n=== Períodos Académicos ===')
for p in AcademicPeriod.objects.all():
    print(f'  [{p.pk}] {p.code} ({p.start_date} - {p.end_date})')
