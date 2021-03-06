/*
 * This file is part of system-settings
 *
 * Copyright (C) 2013 Canonical Ltd.
 *
 * Contact: William Hua <william.hua@canonical.com>
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3, as published
 * by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranties of
 * MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef KEYBOARD_LAYOUT_H
#define KEYBOARD_LAYOUT_H

#include <QtCore>

class KeyboardLayout : public QObject
{
private:

    Q_OBJECT

    Q_PROPERTY(QString name
               READ name
               CONSTANT)

    Q_PROPERTY(QString language
               READ language
               CONSTANT)

    Q_PROPERTY(QString displayName
               READ displayName
               CONSTANT)

public:

    explicit KeyboardLayout(const QString &name        = QString(),
                            const QString &language    = QString(),
                            const QString &displayName = QString(),
                            const QString &shortName   = QString(),
                            QObject       *parent      = nullptr);

    explicit KeyboardLayout(const QFileInfo &fileInfo,
                            QObject         *parent   = nullptr);

    const QString &name() const;
    const QString &language() const;
    const QString &displayName() const;
    const QString &shortName() const;

private:

    QString m_name;
    QString m_language;
    QString m_displayName;
    QString m_shortName;
};

#endif // KEYBOARD_LAYOUT_H
