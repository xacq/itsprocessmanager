from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ("processes", "0002_storagetype_created_at_storagetype_updated_at_and_more"),
    ]

    operations = [
        migrations.AddField(
            model_name="operationactortemplate",
            name="participant",
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.PROTECT,
                related_name="operation_actor_templates",
                to="processes.user",
                limit_choices_to={"role": "PARTICIPANT"},
            ),
        ),
    ]
