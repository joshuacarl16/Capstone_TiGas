# Generated by Django 4.2.1 on 2023-07-27 07:50

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backend', '0005_alter_station_distance'),
    ]

    operations = [
        migrations.AlterField(
            model_name='station',
            name='gasTypeInfo',
            field=models.JSONField(null=True),
        ),
        migrations.AlterField(
            model_name='station',
            name='gasTypes',
            field=models.JSONField(null=True),
        ),
        migrations.AlterField(
            model_name='station',
            name='services',
            field=models.JSONField(null=True),
        ),
    ]
