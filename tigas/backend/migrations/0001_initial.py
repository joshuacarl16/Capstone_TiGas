# Generated by Django 4.2.1 on 2023-07-24 08:46

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Station',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('updated', models.DateTimeField(auto_now=True)),
                ('created', models.DateTimeField(auto_now_add=True)),
                ('imagePath', models.CharField(max_length=255)),
                ('brand', models.CharField(max_length=50)),
                ('address', models.CharField(max_length=255)),
                ('distance', models.FloatField()),
                ('gasTypes', models.JSONField()),
                ('gasTypeInfo', models.JSONField()),
                ('services', models.JSONField()),
            ],
            options={
                'ordering': ['-updated'],
            },
        ),
    ]
