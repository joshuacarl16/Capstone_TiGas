# Generated by Django 4.2.1 on 2023-08-01 14:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backend', '0008_review'),
    ]

    operations = [
        migrations.AddField(
            model_name='review',
            name='comments',
            field=models.TextField(null=True),
        ),
        migrations.AlterField(
            model_name='review',
            name='posted_by',
            field=models.CharField(default='Unknown', max_length=255),
        ),
        migrations.AlterField(
            model_name='review',
            name='review',
            field=models.JSONField(null=True),
        ),
    ]
