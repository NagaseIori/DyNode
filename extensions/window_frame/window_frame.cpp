#pragma once
#include "stdafx.h"
#include <vector>
#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
#include <optional>
#endif
#include <stdint.h>
#include <cstring>
#include <tuple>
using namespace std;

#define dllg /* tag */

#if defined(WIN32)
#define dllx extern "C" __declspec(dllexport)
#elif defined(GNUC)
#define dllx extern "C" __attribute__ ((visibility("default"))) 
#else
#define dllx extern "C"
#endif

#ifdef _WINDEF_
typedef HWND GAME_HWND;
#endif

struct gml_buffer {
private:
	uint8_t* _data;
	int32_t _size;
	int32_t _tell;
public:
	gml_buffer() : _data(nullptr), _tell(0), _size(0) {}
	gml_buffer(uint8_t* data, int32_t size, int32_t tell) : _data(data), _size(size), _tell(tell) {}

	inline uint8_t* data() { return _data; }
	inline int32_t tell() { return _tell; }
	inline int32_t size() { return _size; }
};

class gml_istream {
	uint8_t* pos;
	uint8_t* start;
public:
	gml_istream(void* origin) : pos((uint8_t*)origin), start((uint8_t*)origin) {}

	template<class T> T read() {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be read");
		T result{};
		std::memcpy(&result, pos, sizeof(T));
		pos += sizeof(T);
		return result;
	}

	char* read_string() {
		char* r = (char*)pos;
		while (*pos != 0) pos++;
		pos++;
		return r;
	}

	template<class T> std::vector<T> read_vector() {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be read");
		auto n = read<uint32_t>();
		std::vector<T> vec(n);
		std::memcpy(vec.data(), pos, sizeof(T) * n);
		pos += sizeof(T) * n;
		return vec;
	}

	gml_buffer read_gml_buffer() {
		auto _data = (uint8_t*)read<int64_t>();
		auto _size = read<int32_t>();
		auto _tell = read<int32_t>();
		return gml_buffer(_data, _size, _tell);
	}

	#pragma region Tuples
	#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
	template<typename... Args>
	std::tuple<Args...> read_tuple() {
		std::tuple<Args...> tup;
		std::apply([this](auto&&... arg) {
			((
				arg = this->read<std::remove_reference_t<decltype(arg)>>()
				), ...);
			}, tup);
		return tup;
	}

	template<class T> optional<T> read_optional() {
		if (read<bool>()) {
			return read<T>;
		} else return {};
	}
	#else
	template<class A, class B> std::tuple<A, B> read_tuple() {
		A a = read<A>();
		B b = read<B>();
		return std::tuple<A, B>(a, b);
	}

	template<class A, class B, class C> std::tuple<A, B, C> read_tuple() {
		A a = read<A>();
		B b = read<B>();
		C c = read<C>();
		return std::tuple<A, B, C>(a, b, c);
	}

	template<class A, class B, class C, class D> std::tuple<A, B, C, D> read_tuple() {
		A a = read<A>();
		B b = read<B>();
		C c = read<C>();
		D d = read<d>();
		return std::tuple<A, B, C, D>(a, b, c, d);
	}
	#endif
};

class gml_ostream {
	uint8_t* pos;
	uint8_t* start;
public:
	gml_ostream(void* origin) : pos((uint8_t*)origin), start((uint8_t*)origin) {}

	template<class T> void write(T val) {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be write");
		memcpy(pos, &val, sizeof(T));
		pos += sizeof(T);
	}

	void write_string(const char* s) {
		for (int i = 0; s[i] != 0; i++) write<char>(s[i]);
		write<char>(0);
	}

	template<class T> void write_vector(std::vector<T>& vec) {
		static_assert(std::is_trivially_copyable_v<T>, "T must be trivially copyable to be write");
		auto n = vec.size();
		write<uint32_t>(n);
		memcpy(pos, vec.data(), n * sizeof(T));
		pos += n * sizeof(T);
	}

	#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
	template<typename... Args>
	void write_tuple(std::tuple<Args...> tup) {
		std::apply([this](auto&&... arg) {
			(this->write(arg), ...);
			}, tup);
	}

	template<class T> void write_optional(optional<T>& val) {
		auto hasValue = val.has_value();
		write<bool>(hasValue);
		if (hasValue) write<T>(val.value());
	}
	#else
	template<class A, class B> void write_tuple(std::tuple<A, B>& tup) {
		write<A>(std::get<0>(tup));
		write<B>(std::get<1>(tup));
	}
	template<class A, class B, class C> void write_tuple(std::tuple<A, B, C>& tup) {
		write<A>(std::get<0>(tup));
		write<B>(std::get<1>(tup));
		write<C>(std::get<2>(tup));
	}
	template<class A, class B, class C, class D> void write_tuple(std::tuple<A, B, C, D>& tup) {
		write<A>(std::get<0>(tup));
		write<B>(std::get<1>(tup));
		write<C>(std::get<2>(tup));
		write<D>(std::get<3>(tup));
	}
	#endif
};
//{{NO_DEPENDENCIES}}
// Microsoft Visual C++ generated include file.
// Used by window_frame.rc

// Next default values for new objects
// 
#ifdef APSTUDIO_INVOKED
#ifndef APSTUDIO_READONLY_SYMBOLS
#define _APS_NEXT_RESOURCE_VALUE        101
#define _APS_NEXT_COMMAND_VALUE         40001
#define _APS_NEXT_CONTROL_VALUE         1001
#define _APS_NEXT_SYMED_VALUE           101
#endif
#endif
// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once
#include <stdint.h>

#ifdef _WINDOWS
	#include "targetver.h"
	
	#define WIN32_LEAN_AND_MEAN // Exclude rarely-used stuff from Windows headers
	#include <windows.h>
#endif

#if defined(WIN32)
#define dllx extern "C" __declspec(dllexport)
#elif defined(GNUC)
#define dllx extern "C" __attribute__ ((visibility("default"))) 
#else
#define dllx extern "C"
#endif

#define _trace // requires user32.lib;Kernel32.lib

#ifdef _trace
#ifdef _WINDOWS
void trace(const char* format, ...);
void tracew(const wchar_t* format, ...);
#else
#define trace(...) { printf("[window_frame:%d] ", __LINE__); printf(__VA_ARGS__); printf("\n"); fflush(stdout); }
#endif
#endif
void trace_winmsg(const char* name, UINT msg, WPARAM wParam, LPARAM lParam);

void yal_memset(void* at, int fill, size_t len);

wchar_t* yal_strcpy(wchar_t* str, const wchar_t* val, size_t size);
template<size_t size> wchar_t* yal_strcpy(wchar_t(&str)[size], const wchar_t* val) {
	return yal_strcpy(str, val, size);
}

wchar_t* yal_strcat(wchar_t* str, const wchar_t* val, size_t size);
template<size_t size> wchar_t* yal_strcat(wchar_t(&str)[size], const wchar_t* val) {
	return yal_strcat(str, val, size);
}

void* yal_alloc(size_t bytes);
template<typename T> T* yal_alloc_arr(size_t count = 1) {
	return (T*)yal_alloc(sizeof(T) * count);
}
void* yal_realloc(void* thing, size_t bytes);
template<typename T> T* yal_realloc_arr(T* arr, size_t count) {
	return (T*)yal_realloc(arr, sizeof(T) * count);
}
bool yal_free(void* thing);

template<typename T> struct yal_set {
private:
	T* _arr;
	size_t _length;
	size_t _capacity;
public:
	yal_set() {}
	yal_set(size_t capacity) { init(capacity); }
	void init(size_t capacity = 4) {
		_capacity = capacity;
		_length = 0;
		_arr = yal_alloc_arr<T>(_capacity);
	}

	static const size_t npos = MAXSIZE_T;
	size_t find(T val) {
		for (size_t i = 0; i < _length; i++) {
			if (_arr[i] == val) return i;
		}
		return npos;
	}
	inline bool contains(T val) {
		return find(val) != npos;
	}

	bool add(T val) {
		if (find(val) != npos) return false;
		if (_length >= _capacity) {
			_capacity *= 2;
			_arr = yal_realloc_arr(_arr, _capacity);
		}
		_arr[_length++] = val;
		return true;
	}
	bool remove(T val) {
		auto i = find(val);
		if (i == npos) return false;
		_length -= 1;
		for (; i < _length; i++) _arr[i] = _arr[i + 1];
		return true;
	}
	bool set(T val, bool on) {
		if (on) return add(val); else return remove(val);
	}
};

#include "gml_ext.h"

// TODO: reference additional headers your program requires here
#pragma once

// Including SDKDDKVer.h defines the highest available Windows platform.

// If you wish to build your application for a previous Windows platform, include WinSDKVer.h and
// set the _WIN32_WINNT macro to the platform you wish to support before including SDKDDKVer.h.

#include <SDKDDKVer.h>
#pragma once
#include "stdafx.h"
extern HWND game_hwnd, frame_hwnd;
extern bool frame_bound;
#define active_hwnd (frame_bound ? frame_hwnd : game_hwnd)

inline HWND GetWindowFramePair(HWND window) {
	return (HWND)GetWindowLongPtrW(window, GWLP_USERDATA);
}
inline void SetWindowFramePair(HWND window, HWND pair) {
	SetWindowLongPtrW(window, GWLP_USERDATA, (LONG_PTR)pair);
}

extern yal_set<WPARAM> queued_syscommands;
extern yal_set<WPARAM> game_blocked_syscommands;
extern yal_set<WPARAM> game_hooked_syscommands;
extern bool game_hook_syscommands;
RECT window_rect();

bool window_frame_set_visible_impl(bool show, bool setvis);
bool window_frame_set_rect_impl(int x, int y, int w, int h, bool show);

#define dllnx dllx
/// ->bool
dllnx double window_frame_sync_icons();
/// ->bool
dllnx double window_frame_set_caption(const char* text);
#undef dllnx

#define WM_WF_SYSCOMMAND (WM_APP + 1)
// game: mark hooked command, frame: run command
#define WM_WF_CALL (WM_APP + 2)
enum class WindowFrameCall_t {
	DisableSysCommand = 1,
	EnableSysCommand,
	IsSysCommandEnabled,

	HookSysCommand,
	UnhookSysCommand,
	IsSysCommandHooked,

	SetBackgroundColor,
	SetMinWidth,
	SetMinHeight,
	SetMaxWidth,
	SetMaxHeight,

	SetStdOut,
};

inline LRESULT WindowFrameCall(WindowFrameCall_t conf, LPARAM lParam) {
	return SendMessageW(frame_hwnd, WM_WF_CALL, (WPARAM)conf, (LPARAM)lParam);
}#include "gml_ext.h"
extern double window_command_check(int button);
dllx double window_command_check_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_button;
	_arg_button = _in.read<int>();
	return window_command_check(_arg_button);
}

extern int window_command_run(int command, int lParam);
dllx double window_command_run_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_command;
	_arg_command = _in.read<int>();
	int _arg_lParam;
	if (_in.read<bool>()) {
		_arg_lParam = _in.read<int>();
	} else _arg_lParam = 0;
	return window_command_run(_arg_command, _arg_lParam);
}

extern bool window_command_hook(int button);
dllx double window_command_hook_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_button;
	_arg_button = _in.read<int>();
	return window_command_hook(_arg_button);
}

extern bool window_command_unhook(int button);
dllx double window_command_unhook_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_button;
	_arg_button = _in.read<int>();
	return window_command_unhook(_arg_button);
}

extern bool window_command_get_hooked(int button);
dllx double window_command_get_hooked_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_button;
	_arg_button = _in.read<int>();
	return window_command_get_hooked(_arg_button);
}

extern bool window_command_set_hooked(int button, bool hook);
dllx double window_command_set_hooked_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_button;
	_arg_button = _in.read<int>();
	bool _arg_hook;
	_arg_hook = _in.read<bool>();
	return window_command_set_hooked(_arg_button, _arg_hook);
}

extern bool window_command_get_active(int command);
dllx double window_command_get_active_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_command;
	_arg_command = _in.read<int>();
	return window_command_get_active(_arg_command);
}

extern bool window_command_set_active(int command, bool val);
dllx double window_command_set_active_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_command;
	_arg_command = _in.read<int>();
	bool _arg_val;
	_arg_val = _in.read<bool>();
	return window_command_set_active(_arg_command, _arg_val);
}

extern bool window_frame_init(GAME_HWND hwnd, int x, int y, int w, int h, const char* title);
dllx double window_frame_init_raw(void* _in_ptr, double _in_ptr_size, char* _arg_title) {
	gml_istream _in(_in_ptr);
	GAME_HWND _arg_hwnd;
	_arg_hwnd = (GAME_HWND)_in.read<uint64_t>();
	int _arg_x;
	_arg_x = _in.read<int>();
	int _arg_y;
	_arg_y = _in.read<int>();
	int _arg_w;
	_arg_w = _in.read<int>();
	int _arg_h;
	_arg_h = _in.read<int>();
	return window_frame_init(_arg_hwnd, _arg_x, _arg_y, _arg_w, _arg_h, _arg_title);
}

extern double window_frame_set_background(int color);
dllx double window_frame_set_background_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_color;
	_arg_color = _in.read<int>();
	return window_frame_set_background(_arg_color);
}

extern bool window_frame_set_region(int x, int y, int width, int height);
dllx double window_frame_set_region_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_x;
	_arg_x = _in.read<int>();
	int _arg_y;
	_arg_y = _in.read<int>();
	int _arg_width;
	_arg_width = _in.read<int>();
	int _arg_height;
	_arg_height = _in.read<int>();
	return window_frame_set_region(_arg_x, _arg_y, _arg_width, _arg_height);
}

extern tuple<int, int, int, int> window_frame_get_rect();
dllx double window_frame_get_rect_raw(void* _inout_ptr, double _inout_ptr_size) {
	gml_istream _in(_inout_ptr);
	tuple<int, int, int, int> _ret = window_frame_get_rect();
	gml_ostream _out(_inout_ptr);
	_out.write_tuple<int, int, int, int>(_ret);
	return 1;
}

extern bool window_frame_set_rect(int x, int y, int width, int height);
dllx double window_frame_set_rect_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_x;
	_arg_x = _in.read<int>();
	int _arg_y;
	_arg_y = _in.read<int>();
	int _arg_width;
	_arg_width = _in.read<int>();
	int _arg_height;
	_arg_height = _in.read<int>();
	return window_frame_set_rect(_arg_x, _arg_y, _arg_width, _arg_height);
}

extern bool window_frame_set_min_size(int minWidth, int minHeight);
dllx double window_frame_set_min_size_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_minWidth;
	_arg_minWidth = _in.read<int>();
	int _arg_minHeight;
	_arg_minHeight = _in.read<int>();
	return window_frame_set_min_size(_arg_minWidth, _arg_minHeight);
}

extern bool window_frame_set_max_size(int maxWidth, int maxHeight);
dllx double window_frame_set_max_size_raw(void* _in_ptr, double _in_ptr_size) {
	gml_istream _in(_in_ptr);
	int _arg_maxWidth;
	_arg_maxWidth = _in.read<int>();
	int _arg_maxHeight;
	_arg_maxHeight = _in.read<int>();
	return window_frame_set_max_size(_arg_maxWidth, _arg_maxHeight);
}

// stdafx.cpp : source file that includes just the standard includes
// window_frame.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"
#include <strsafe.h>
#include <intrin.h>

#if _WINDOWS
// http://computer-programming-forum.com/7-vc.net/07649664cea3e3d7.htm
extern "C" int _fltused = 0;

/// https://stackoverflow.com/a/55011686/5578773
extern "C" unsigned int _dtoui3(const double x) {
	return (unsigned int)_mm_cvttsd_si32(_mm_set_sd(x));
}
#endif

// TODO: reference any additional headers you need in STDAFX.H
// and not in this file
#ifdef _WINDOWS
#ifdef _trace
// https://yal.cc/printf-without-standard-library/
void trace(const char* pszFormat, ...) {
	char buf[1025];
	va_list argList;
	va_start(argList, pszFormat);
	wvsprintfA(buf, pszFormat, argList);
	va_end(argList);
	DWORD done;
	auto len = strlen(buf);
	buf[len] = '\n';
	buf[++len] = 0;
	WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), buf, len, &done, NULL);
}
void tracew(const wchar_t* pszFormat, ...) {
	wchar_t buf[1025];
	va_list argList;
	va_start(argList, pszFormat);
	wvsprintfW(buf, pszFormat, argList);
	va_end(argList);
	DWORD done;
	auto len = lstrlenW(buf);
	buf[len] = '\n';
	buf[++len] = 0;
	WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), buf, len*sizeof(wchar_t), &done, NULL);
}
#endif
#endif
//#define winmsg_names
#ifdef winmsg_names
static const char* winmsg_get_name(UINT msg) {
	/* executed on WinUser.h
	var found = {};
	seekAll(/#define\s+(WM_\w+)\s+(0x[0-9a-fA-F]+)/g, function(m) {
	if (found[m[2]]) return; else found[m[2]] = true;
	return 'case ' + m[2] + ': return "' + m[1] + '";';
	});
	*/
	switch (msg) {
		case 0x0000: return "WM_NULL";
		case 0x0001: return "WM_CREATE";
		case 0x0002: return "WM_DESTROY";
		case 0x0003: return "WM_MOVE";
		case 0x0005: return "WM_SIZE";
		case 0x0006: return "WM_ACTIVATE";
		case 0x0007: return "WM_SETFOCUS";
		case 0x0008: return "WM_KILLFOCUS";
		case 0x000A: return "WM_ENABLE";
		case 0x000B: return "WM_SETREDRAW";
		case 0x000C: return "WM_SETTEXT";
		case 0x000D: return "WM_GETTEXT";
		case 0x000E: return "WM_GETTEXTLENGTH";
		case 0x000F: return "WM_PAINT";
		case 0x0010: return "WM_CLOSE";
		case 0x0011: return "WM_QUERYENDSESSION";
		case 0x0013: return "WM_QUERYOPEN";
		case 0x0016: return "WM_ENDSESSION";
		case 0x0012: return "WM_QUIT";
		case 0x0014: return "WM_ERASEBKGND";
		case 0x0015: return "WM_SYSCOLORCHANGE";
		case 0x0018: return "WM_SHOWWINDOW";
		case 0x001A: return "WM_WININICHANGE";
		case 0x001B: return "WM_DEVMODECHANGE";
		case 0x001C: return "WM_ACTIVATEAPP";
		case 0x001D: return "WM_FONTCHANGE";
		case 0x001E: return "WM_TIMECHANGE";
		case 0x001F: return "WM_CANCELMODE";
		case 0x0020: return "WM_SETCURSOR";
		case 0x0021: return "WM_MOUSEACTIVATE";
		case 0x0022: return "WM_CHILDACTIVATE";
		case 0x0023: return "WM_QUEUESYNC";
		case 0x0024: return "WM_GETMINMAXINFO";
		case 0x0026: return "WM_PAINTICON";
		case 0x0027: return "WM_ICONERASEBKGND";
		case 0x0028: return "WM_NEXTDLGCTL";
		case 0x002A: return "WM_SPOOLERSTATUS";
		case 0x002B: return "WM_DRAWITEM";
		case 0x002C: return "WM_MEASUREITEM";
		case 0x002D: return "WM_DELETEITEM";
		case 0x002E: return "WM_VKEYTOITEM";
		case 0x002F: return "WM_CHARTOITEM";
		case 0x0030: return "WM_SETFONT";
		case 0x0031: return "WM_GETFONT";
		case 0x0032: return "WM_SETHOTKEY";
		case 0x0033: return "WM_GETHOTKEY";
		case 0x0037: return "WM_QUERYDRAGICON";
		case 0x0039: return "WM_COMPAREITEM";
		case 0x003D: return "WM_GETOBJECT";
		case 0x0041: return "WM_COMPACTING";
		case 0x0044: return "WM_COMMNOTIFY";
		case 0x0046: return "WM_WINDOWPOSCHANGING";
		case 0x0047: return "WM_WINDOWPOSCHANGED";
		case 0x0048: return "WM_POWER";
		case 0x004A: return "WM_COPYDATA";
		case 0x004B: return "WM_CANCELJOURNAL";
		case 0x004E: return "WM_NOTIFY";
		case 0x0050: return "WM_INPUTLANGCHANGEREQUEST";
		case 0x0051: return "WM_INPUTLANGCHANGE";
		case 0x0052: return "WM_TCARD";
		case 0x0053: return "WM_HELP";
		case 0x0054: return "WM_USERCHANGED";
		case 0x0055: return "WM_NOTIFYFORMAT";
		case 0x007B: return "WM_CONTEXTMENU";
		case 0x007C: return "WM_STYLECHANGING";
		case 0x007D: return "WM_STYLECHANGED";
		case 0x007E: return "WM_DISPLAYCHANGE";
		case 0x007F: return "WM_GETICON";
		case 0x0080: return "WM_SETICON";
		case 0x0081: return "WM_NCCREATE";
		case 0x0082: return "WM_NCDESTROY";
		case 0x0083: return "WM_NCCALCSIZE";
		case 0x0084: return "WM_NCHITTEST";
		case 0x0085: return "WM_NCPAINT";
		case 0x0086: return "WM_NCACTIVATE";
		case 0x0087: return "WM_GETDLGCODE";
		case 0x0088: return "WM_SYNCPAINT";
		case 0x00A0: return "WM_NCMOUSEMOVE";
		case 0x00A1: return "WM_NCLBUTTONDOWN";
		case 0x00A2: return "WM_NCLBUTTONUP";
		case 0x00A3: return "WM_NCLBUTTONDBLCLK";
		case 0x00A4: return "WM_NCRBUTTONDOWN";
		case 0x00A5: return "WM_NCRBUTTONUP";
		case 0x00A6: return "WM_NCRBUTTONDBLCLK";
		case 0x00A7: return "WM_NCMBUTTONDOWN";
		case 0x00A8: return "WM_NCMBUTTONUP";
		case 0x00A9: return "WM_NCMBUTTONDBLCLK";
		case 0x00AB: return "WM_NCXBUTTONDOWN";
		case 0x00AC: return "WM_NCXBUTTONUP";
		case 0x00AD: return "WM_NCXBUTTONDBLCLK";
		case 0x00FE: return "WM_INPUT_DEVICE_CHANGE";
		case 0x00FF: return "WM_INPUT";
		case 0x0100: return "WM_KEYFIRST";
		case 0x0101: return "WM_KEYUP";
		case 0x0102: return "WM_CHAR";
		case 0x0103: return "WM_DEADCHAR";
		case 0x0104: return "WM_SYSKEYDOWN";
		case 0x0105: return "WM_SYSKEYUP";
		case 0x0106: return "WM_SYSCHAR";
		case 0x0107: return "WM_SYSDEADCHAR";
		case 0x0109: return "WM_UNICHAR";
		case 0x0108: return "WM_KEYLAST";
		case 0x010D: return "WM_IME_STARTCOMPOSITION";
		case 0x010E: return "WM_IME_ENDCOMPOSITION";
		case 0x010F: return "WM_IME_COMPOSITION";
		case 0x0110: return "WM_INITDIALOG";
		case 0x0111: return "WM_COMMAND";
		case 0x0112: return "WM_SYSCOMMAND";
		case 0x0113: return "WM_TIMER";
		case 0x0114: return "WM_HSCROLL";
		case 0x0115: return "WM_VSCROLL";
		case 0x0116: return "WM_INITMENU";
		case 0x0117: return "WM_INITMENUPOPUP";
		case 0x0119: return "WM_GESTURE";
		case 0x011A: return "WM_GESTURENOTIFY";
		case 0x011F: return "WM_MENUSELECT";
		case 0x0120: return "WM_MENUCHAR";
		case 0x0121: return "WM_ENTERIDLE";
		case 0x0122: return "WM_MENURBUTTONUP";
		case 0x0123: return "WM_MENUDRAG";
		case 0x0124: return "WM_MENUGETOBJECT";
		case 0x0125: return "WM_UNINITMENUPOPUP";
		case 0x0126: return "WM_MENUCOMMAND";
		case 0x0127: return "WM_CHANGEUISTATE";
		case 0x0128: return "WM_UPDATEUISTATE";
		case 0x0129: return "WM_QUERYUISTATE";
		case 0x0132: return "WM_CTLCOLORMSGBOX";
		case 0x0133: return "WM_CTLCOLOREDIT";
		case 0x0134: return "WM_CTLCOLORLISTBOX";
		case 0x0135: return "WM_CTLCOLORBTN";
		case 0x0136: return "WM_CTLCOLORDLG";
		case 0x0137: return "WM_CTLCOLORSCROLLBAR";
		case 0x0138: return "WM_CTLCOLORSTATIC";
		case 0x0200: return "WM_MOUSEFIRST";
		case 0x0201: return "WM_LBUTTONDOWN";
		case 0x0202: return "WM_LBUTTONUP";
		case 0x0203: return "WM_LBUTTONDBLCLK";
		case 0x0204: return "WM_RBUTTONDOWN";
		case 0x0205: return "WM_RBUTTONUP";
		case 0x0206: return "WM_RBUTTONDBLCLK";
		case 0x0207: return "WM_MBUTTONDOWN";
		case 0x0208: return "WM_MBUTTONUP";
		case 0x0209: return "WM_MBUTTONDBLCLK";
		case 0x020A: return "WM_MOUSEWHEEL";
		case 0x020B: return "WM_XBUTTONDOWN";
		case 0x020C: return "WM_XBUTTONUP";
		case 0x020D: return "WM_XBUTTONDBLCLK";
		case 0x020E: return "WM_MOUSEHWHEEL";
		case 0x0210: return "WM_PARENTNOTIFY";
		case 0x0211: return "WM_ENTERMENULOOP";
		case 0x0212: return "WM_EXITMENULOOP";
		case 0x0213: return "WM_NEXTMENU";
		case 0x0214: return "WM_SIZING";
		case 0x0215: return "WM_CAPTURECHANGED";
		case 0x0216: return "WM_MOVING";
		case 0x0218: return "WM_POWERBROADCAST";
		case 0x0219: return "WM_DEVICECHANGE";
		case 0x0220: return "WM_MDICREATE";
		case 0x0221: return "WM_MDIDESTROY";
		case 0x0222: return "WM_MDIACTIVATE";
		case 0x0223: return "WM_MDIRESTORE";
		case 0x0224: return "WM_MDINEXT";
		case 0x0225: return "WM_MDIMAXIMIZE";
		case 0x0226: return "WM_MDITILE";
		case 0x0227: return "WM_MDICASCADE";
		case 0x0228: return "WM_MDIICONARRANGE";
		case 0x0229: return "WM_MDIGETACTIVE";
		case 0x0230: return "WM_MDISETMENU";
		case 0x0231: return "WM_ENTERSIZEMOVE";
		case 0x0232: return "WM_EXITSIZEMOVE";
		case 0x0233: return "WM_DROPFILES";
		case 0x0234: return "WM_MDIREFRESHMENU";
		case 0x238: return "WM_POINTERDEVICECHANGE";
		case 0x239: return "WM_POINTERDEVICEINRANGE";
		case 0x23A: return "WM_POINTERDEVICEOUTOFRANGE";
		case 0x0240: return "WM_TOUCH";
		case 0x0241: return "WM_NCPOINTERUPDATE";
		case 0x0242: return "WM_NCPOINTERDOWN";
		case 0x0243: return "WM_NCPOINTERUP";
		case 0x0245: return "WM_POINTERUPDATE";
		case 0x0246: return "WM_POINTERDOWN";
		case 0x0247: return "WM_POINTERUP";
		case 0x0249: return "WM_POINTERENTER";
		case 0x024A: return "WM_POINTERLEAVE";
		case 0x024B: return "WM_POINTERACTIVATE";
		case 0x024C: return "WM_POINTERCAPTURECHANGED";
		case 0x024D: return "WM_TOUCHHITTESTING";
		case 0x024E: return "WM_POINTERWHEEL";
		case 0x024F: return "WM_POINTERHWHEEL";
		case 0x0251: return "WM_POINTERROUTEDTO";
		case 0x0252: return "WM_POINTERROUTEDAWAY";
		case 0x0253: return "WM_POINTERROUTEDRELEASED";
		case 0x0281: return "WM_IME_SETCONTEXT";
		case 0x0282: return "WM_IME_NOTIFY";
		case 0x0283: return "WM_IME_CONTROL";
		case 0x0284: return "WM_IME_COMPOSITIONFULL";
		case 0x0285: return "WM_IME_SELECT";
		case 0x0286: return "WM_IME_CHAR";
		case 0x0288: return "WM_IME_REQUEST";
		case 0x0290: return "WM_IME_KEYDOWN";
		case 0x0291: return "WM_IME_KEYUP";
		case 0x02A1: return "WM_MOUSEHOVER";
		case 0x02A3: return "WM_MOUSELEAVE";
		case 0x02A0: return "WM_NCMOUSEHOVER";
		case 0x02A2: return "WM_NCMOUSELEAVE";
		case 0x02B1: return "WM_WTSSESSION_CHANGE";
		case 0x02c0: return "WM_TABLET_FIRST";
		case 0x02df: return "WM_TABLET_LAST";
		case 0x02E0: return "WM_DPICHANGED";
		case 0x02E2: return "WM_DPICHANGED_BEFOREPARENT";
		case 0x02E3: return "WM_DPICHANGED_AFTERPARENT";
		case 0x02E4: return "WM_GETDPISCALEDSIZE";
		case 0x0300: return "WM_CUT";
		case 0x0301: return "WM_COPY";
		case 0x0302: return "WM_PASTE";
		case 0x0303: return "WM_CLEAR";
		case 0x0304: return "WM_UNDO";
		case 0x0305: return "WM_RENDERFORMAT";
		case 0x0306: return "WM_RENDERALLFORMATS";
		case 0x0307: return "WM_DESTROYCLIPBOARD";
		case 0x0308: return "WM_DRAWCLIPBOARD";
		case 0x0309: return "WM_PAINTCLIPBOARD";
		case 0x030A: return "WM_VSCROLLCLIPBOARD";
		case 0x030B: return "WM_SIZECLIPBOARD";
		case 0x030C: return "WM_ASKCBFORMATNAME";
		case 0x030D: return "WM_CHANGECBCHAIN";
		case 0x030E: return "WM_HSCROLLCLIPBOARD";
		case 0x030F: return "WM_QUERYNEWPALETTE";
		case 0x0310: return "WM_PALETTEISCHANGING";
		case 0x0311: return "WM_PALETTECHANGED";
		case 0x0312: return "WM_HOTKEY";
		case 0x0317: return "WM_PRINT";
		case 0x0318: return "WM_PRINTCLIENT";
		case 0x0319: return "WM_APPCOMMAND";
		case 0x031A: return "WM_THEMECHANGED";
		case 0x031D: return "WM_CLIPBOARDUPDATE";
		case 0x031E: return "WM_DWMCOMPOSITIONCHANGED";
		case 0x031F: return "WM_DWMNCRENDERINGCHANGED";
		case 0x0320: return "WM_DWMCOLORIZATIONCOLORCHANGED";
		case 0x0321: return "WM_DWMWINDOWMAXIMIZEDCHANGE";
		case 0x0323: return "WM_DWMSENDICONICTHUMBNAIL";
		case 0x0326: return "WM_DWMSENDICONICLIVEPREVIEWBITMAP";
		case 0x033F: return "WM_GETTITLEBARINFOEX";
		case 0x0358: return "WM_HANDHELDFIRST";
		case 0x035F: return "WM_HANDHELDLAST";
		case 0x0360: return "WM_AFXFIRST";
		case 0x037F: return "WM_AFXLAST";
		case 0x0380: return "WM_PENWINFIRST";
		case 0x038F: return "WM_PENWINLAST";
		case 0x8000: return "WM_APP";
		case 0x0400: return "WM_USER";
	}
	return NULL;
}
#endif
void trace_winmsg(const char* prefix, UINT msg, WPARAM wParam, LPARAM lParam) {
	#ifdef winmsg_names
	switch (msg) {
		case WM_NCHITTEST:
		case WM_MOUSEMOVE:
		case 0x20:
			return;
	}
	auto name = winmsg_get_name(msg);
	if (name) {
		trace("%s: msg=%x|%s wp=%d|0x%x, lp=%d|0x%x", prefix, msg, name, wParam, lParam);
	} else trace("%s: msg=%x wp=%d|0x%x, lp=%d|0x%x", prefix, msg, wParam, lParam);
	#endif
}


void yal_memset(void* at, int fill, size_t len) {
	auto ptr = (uint8_t*)at;
	while (len != 0) {
		*ptr++ = (uint8_t)fill;
		len = (len - 1) & 0x7FFFFFFFu; // can't be just len-- or compiler will optimize this to a std memset
	}
}
wchar_t* yal_strcpy(wchar_t* str, const wchar_t* val, size_t size) {
	size_t i = 0;
	while (val[i] && i < size) {
		str[i] = val[i];
		i++;
	}
	if (i >= size) i--;
	str[i] = 0;
	return str + i;
}
wchar_t* yal_strcat(wchar_t* str, const wchar_t* val, size_t size) {
	size_t i = 0;
	while (str[i] && i < size) i++;
	size_t k = 0;
	while (val[k] && i < size) {
		str[i++] = val[k++];
	}
	if (i >= size) i--;
	str[i] = 0;
	return str + i;
}
void* yal_alloc(size_t bytes) {
	return HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, bytes);
}
void* yal_realloc(void* thing, size_t bytes) {
	return HeapReAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, thing, bytes);
}
bool yal_free(void* thing) {
	return HeapFree(GetProcessHeap(), 0, thing);
}
#include "stdafx.h"
#include "window_frame.h"
yal_set<WPARAM> queued_syscommands;
yal_set<WPARAM> game_blocked_syscommands;
yal_set<WPARAM> game_hooked_syscommands;
bool game_hook_syscommands;
// Window Commands implementation for Window Frame

dllg double window_command_check(int button) {
	return queued_syscommands.remove(button);
}

dllg int window_command_run(int command, int lParam = 0) {
	if (frame_bound) {
		return SendMessageW(frame_hwnd, WM_WF_SYSCOMMAND, (WPARAM)command, (LPARAM)lParam);
	} else {
		auto _hook = game_hook_syscommands;
		game_hook_syscommands = false;
		auto result = SendMessageW(game_hwnd, WM_SYSCOMMAND, (WPARAM)command, (LPARAM)lParam);
		game_hook_syscommands = _hook;
		return result;
	}
}

dllg bool window_command_hook(int button) {
	WindowFrameCall(WindowFrameCall_t::HookSysCommand, button);
	game_hooked_syscommands.add(button);
	return true;
}

dllg bool window_command_unhook(int button) {
	WindowFrameCall(WindowFrameCall_t::UnhookSysCommand, button);
	game_hooked_syscommands.remove(button);
	return true;
}

dllg bool window_command_get_hooked(int button) {
	if (frame_bound) {
		return WindowFrameCall(WindowFrameCall_t::IsSysCommandHooked, button);
	} else {
		return game_hooked_syscommands.contains(button);
	}
}

dllg bool window_command_set_hooked(int button, bool hook) {
	if (hook) {
		return window_command_hook(button);
	} else return window_command_unhook(button);
}

/// Operation modes:
/// val=-1: returns current status
/// val>=0: changes status, returns whether successful
bool window_command_proc_active(int command, int val) {
	auto get = val < 0;
	auto setv = val > 0;
	switch (command) {
		case SC_MOVE: case SC_MOUSEMENU: {
			if (get) {
				if (frame_hwnd) {
					return WindowFrameCall(WindowFrameCall_t::IsSysCommandEnabled, command);
				} else {
					return !game_blocked_syscommands.contains(command);
				}
			} else if (setv) {
				game_blocked_syscommands.remove(command);
				return WindowFrameCall(WindowFrameCall_t::EnableSysCommand, command);
			} else {
				game_blocked_syscommands.add(command);
				return WindowFrameCall(WindowFrameCall_t::DisableSysCommand, command);
			}
		} break;
		case SC_CLOSE: {
			auto uid = (UINT)command;
			if (get) {
				auto menu = GetSystemMenu(frame_hwnd, false);
				return (GetMenuState(menu, uid, MF_BYCOMMAND) & MF_GRAYED) == 0;
			}
			game_blocked_syscommands.set(command, !setv);
			auto frame_menu = GetSystemMenu(frame_hwnd, false);
			return EnableMenuItem(frame_menu, uid, MF_BYCOMMAND | (setv ? MF_ENABLED : MF_GRAYED));
		} break;
		default: {
			long styleFlag = -1;
			switch (command) {
				case SC_SIZE: styleFlag = WS_THICKFRAME; break;
				case SC_MINIMIZE: styleFlag = WS_MINIMIZEBOX; break;
				case SC_MAXIMIZE: styleFlag = WS_MAXIMIZEBOX; break;
			}
			if (styleFlag < 0) return false;

			auto hwnd = frame_hwnd;
			auto styleBits = GetWindowLongW(hwnd, GWL_STYLE);
			if (get) {
				return (styleBits & styleFlag) == styleFlag;
			} else if (setv) {
				styleBits |= styleFlag;
			} else styleBits &= ~styleFlag;
			game_blocked_syscommands.set(command, !setv);
			SetWindowLongW(hwnd, GWL_STYLE, styleBits);
			return true;
		} break;
	}
	return false;
}

dllg bool window_command_get_active(int command) {
	return window_command_proc_active(command, -1);
}

dllg bool window_command_set_active(int command, bool val) {
	return window_command_proc_active(command, val ? 1 : 0);
}
/// window_frame.cpp
/// @author YellowAfterlife

#include "stdafx.h"
#include "window_frame.h"
HWND game_hwnd, frame_hwnd;
bool frame_bound;

RECT window_rect() {
	auto hwnd = active_hwnd;
	RECT windowRect, clientRect, adjustedRect{};
	GetClientRect(hwnd, &clientRect);
	adjustedRect.left = clientRect.left; adjustedRect.right = clientRect.right;
	adjustedRect.top = clientRect.top; adjustedRect.bottom = clientRect.bottom;
	AdjustWindowRect(&adjustedRect, GetWindowLong(hwnd, GWL_STYLE), false);
	GetWindowRect(hwnd, &windowRect);
	windowRect.left -= (adjustedRect.left - clientRect.left);
	windowRect.top -= (adjustedRect.top - clientRect.top);
	windowRect.right -= (adjustedRect.right - clientRect.right);
	windowRect.bottom -= (adjustedRect.bottom - clientRect.bottom);
	return windowRect;
}

bool window_frame_set_visible_impl(bool show, bool setvis) {
	if (show == frame_bound) return true;
	auto hwnd = game_hwnd;
	auto fwnd = frame_hwnd;
	auto rect = window_rect();
	//trace("%d,%d,%d,%d", rect.left, rect.top, rect.right, rect.bottom);
	if (show) {
		SetWindowLong(hwnd, GWL_STYLE, GetWindowLong(hwnd, GWL_STYLE) & ~WS_POPUP | WS_CHILD);
		SetParent(hwnd, fwnd);
		SetWindowPos(hwnd, nullptr, 0, 0, 0, 0, SWP_NOSIZE);
		AdjustWindowRect(&rect, GetWindowLong(fwnd, GWL_STYLE), false);
		SetWindowPos(fwnd, nullptr, rect.left, rect.top, 0, 0, SWP_NOSIZE);
		if (setvis) {
			ShowWindow(fwnd, SW_SHOW);
			RedrawWindow(frame_hwnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE);
		}
	} else {
		SetWindowLong(hwnd, GWL_STYLE, GetWindowLong(hwnd, GWL_STYLE) & ~WS_CHILD | WS_POPUP);
		SetParent(hwnd, nullptr);
		SetWindowPos(hwnd, nullptr, rect.left, rect.top, 0, 0, SWP_NOSIZE);
		if (setvis) ShowWindow(fwnd, SW_HIDE);
	}
	SetFocus(hwnd);
	frame_bound = show;
	return true;
}
dllx double window_frame_set_visible_raw(double visible) {
	return window_frame_set_visible_impl(visible > 0.5, true);
}


/// ->bool
dllx double window_frame_set_caption(const char* text) {
	wchar_t wtext[1025];
	MultiByteToWideChar(CP_UTF8, 0, text, -1, wtext, std::size(wtext) - 1);
	wtext[std::size(wtext) - 1] = 0;
	return SetWindowTextW(frame_hwnd, wtext);
}

/// ->bool
dllx double window_frame_sync_icons() {
	auto _game_hwnd = game_hwnd;
	auto _frame_hwnd = frame_hwnd;
	if (!_frame_hwnd) return false;
	SendMessage(_frame_hwnd, WM_SETICON, ICON_SMALL2, SendMessage(_game_hwnd, WM_GETICON, ICON_SMALL2, 0));
	SendMessage(_frame_hwnd, WM_SETICON, ICON_SMALL,  SendMessage(_game_hwnd, WM_GETICON, ICON_SMALL,  0));
	SendMessage(_frame_hwnd, WM_SETICON, ICON_BIG,    SendMessage(_game_hwnd, WM_GETICON, ICON_BIG,    0));
	return true;
}

dllx double window_frame_preinit_raw() {
	return true;
}
#include "window_frame.h"
// added by Samuel V. / time-killer-games

bool window_frame_fakefullscreen = false;

RECT rectprev; RECT clientprev; LONG styleprev;
bool window_frame_set_fakefullscreen_impl(bool full) {
	if (full == window_frame_fakefullscreen) return true;
	auto hwnd = game_hwnd;
	auto fwnd = frame_hwnd;
	auto rect = window_rect();
	//trace("%d,%d,%d,%d", rect.left, rect.top, rect.right, rect.bottom);
	if (full) {
		rectprev = rect;
		GetClientRect(hwnd, &clientprev);
		styleprev = GetWindowLong(fwnd, GWL_STYLE);
		SetWindowLong(fwnd, GWL_STYLE, GetWindowLong(hwnd, GWL_STYLE) & ~WS_CHILD);
		MoveWindow(fwnd, 0, 0,
			GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN), true);
		MoveWindow(hwnd, 0, 0,
			GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN), true);
	} else {
		SetWindowLong(fwnd, GWL_STYLE, styleprev & ~WS_CHILD);
		SetWindowPos(fwnd, nullptr, 0, 0, 0, 0, SWP_NOSIZE);
		AdjustWindowRect(&rectprev, GetWindowLong(fwnd, GWL_STYLE), false);
		MoveWindow(fwnd, rectprev.left, rectprev.top,
			rectprev.right - rectprev.left, rectprev.bottom - rectprev.top, true);
		SetWindowPos(hwnd, nullptr,
			(GetSystemMetrics(SM_CXSCREEN) / 2) - (clientprev.right / 2),
			(GetSystemMetrics(SM_CYSCREEN) / 2) - (clientprev.bottom / 2),
			clientprev.right, clientprev.bottom, 0);
	}
	SetFocus(hwnd);
	window_frame_fakefullscreen = full;
	return true;
}
///
dllx double window_frame_get_fakefullscreen() {
	return window_frame_fakefullscreen;
}
///
dllx double window_frame_set_fakefullscreen(double full) {
	return window_frame_set_fakefullscreen_impl(full > 0.5);
}#include "stdafx.h"
#include "window_frame.h"

static BOOL CALLBACK find_frame_hwnd(HWND hwnd, LPARAM param) {
	DWORD thread = GetWindowThreadProcessId(hwnd, nullptr);
	if (thread == (DWORD)param) {
		frame_hwnd = hwnd;
		return FALSE;
	} else return TRUE;
}

static bool hasFocus;
/// ->bool
dllx double window_frame_has_focus() {
	return hasFocus;
}

WNDPROC wndproc_base;
LRESULT wndproc_hook(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
	trace_winmsg("game", msg, wParam, lParam);
	switch (msg) {
		case WM_ACTIVATE:
			hasFocus = (wParam & 0xFFFF) != 0;
			break;
		case WM_ERASEBKGND:
			return TRUE;
		case WM_WF_SYSCOMMAND:
			queued_syscommands.add(wParam);
			return TRUE;
		case WM_SYSCOMMAND:
			if (!game_hook_syscommands) break;
			if (wParam == SC_KEYMENU) break; // don't touch the system menu!
			auto cmd = wParam & ~15;
			if (game_blocked_syscommands.contains(cmd)) return TRUE;
			if (game_hooked_syscommands.contains(cmd)) {
				queued_syscommands.add(wParam);
				return TRUE;
			}
			break;
	}
	return CallWindowProc(wndproc_base, hwnd, msg, wParam, lParam);
}


dllg bool window_frame_init(GAME_HWND hwnd, int x, int y, int w, int h, const char* title) {
	game_hwnd = hwnd;
	frame_hwnd = NULL;

	// https://stackoverflow.com/a/6924332/5578773
	HMODULE dllModule;
	if (GetModuleHandleExW(
		GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
		(LPCWSTR)&window_frame_init, &dllModule
		) == 0) {
		trace("GetModuleHandleEx failed, error %d", GetLastError());
		return false;
	}
	wchar_t dllPath[MAX_PATH];
	if (GetModuleFileNameW(dllModule, dllPath, std::size(dllPath)) == 0) {
		trace("GetModuleFileName failed, error %d", GetLastError());
		return false;
	}
	//tracew(L"path: <%s>", dllPath);

	WCHAR commandLine[1024];
	if (GetEnvironmentVariableW(L"windir", commandLine, std::size(commandLine)) == 0) {
		trace("GetEnvironmentVariable failed, error %d", GetLastError());
		return false;
	}
	yal_strcat(commandLine, L"\\system32\\rundll32.exe ");
	yal_strcat(commandLine, dllPath);
	yal_strcat(commandLine, L" frame_process");
	//tracew(L"[%s]", commandLine);

	STARTUPINFOW si;
	ZeroMemory(&si, sizeof si);//yal_memset(&si, 0, sizeof si);
	si.cb = sizeof si;
	si.dwFlags = STARTF_USESHOWWINDOW | STARTF_USESTDHANDLES;
	si.wShowWindow = SW_HIDE;
	si.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
	si.hStdError = GetStdHandle(STD_ERROR_HANDLE);
	si.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
	PROCESS_INFORMATION pi;
	ZeroMemory(&pi, sizeof pi);//yal_memset(&pi, 0, sizeof pi);

	if (!CreateProcessW(NULL, commandLine, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
		trace("CreateProcess failed, error %d", GetLastError());
		return false;
	}

	// wait for the frame to load up:
	WaitForInputIdle(pi.hProcess, INFINITE);

	// find the frame hwnd:
	EnumWindows(&find_frame_hwnd, pi.dwThreadId);
	if (frame_hwnd == NULL) {
		trace("Couldn't find the frame hwnd!");
		return false;
	}

	// we don't need these anymore:
	CloseHandle(pi.hThread);
	CloseHandle(pi.hProcess);

	// match the frame to game:
	window_frame_set_caption(title);
	window_frame_sync_icons();

	//
	wndproc_base = (WNDPROC)SetWindowLongPtr(hwnd, GWLP_WNDPROC, (LONG_PTR)wndproc_hook);

	// link the two:
	WindowFrameCall(WindowFrameCall_t::SetStdOut, (LPARAM)GetStdHandle(STD_OUTPUT_HANDLE));
	SetWindowFramePair(frame_hwnd, game_hwnd);
	SetWindowFramePair(game_hwnd, frame_hwnd);
	frame_bound = true;
	window_frame_set_rect_impl(x, y, w, h, true);
	frame_bound = false;
	window_frame_set_visible_impl(true, false);

	return true;
}

static void init() {
	hasFocus = false;
	queued_syscommands.init();
	game_blocked_syscommands.init();
	game_hooked_syscommands.init();
	game_hook_syscommands = true;
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved) {
	switch (fdwReason) {
		case DLL_PROCESS_ATTACH:
			init();
			break;
		case DLL_PROCESS_DETACH:
			//
			break;
	}
	return TRUE;
}#include "window_frame.h"
///
/*dllg tuple<double, double, double, double> window_frame_get_rect() {
	return tuple(

	);
}*/
/// (buffer_addr:ptr)->bool
dllx double window_frame_get_handle(HWND* out) {
	*(uint64_t*)out = 0;
	*out = frame_hwnd;
	return true;
}

// what a disaster
static void htoa10(HANDLE h, char* str) {
	auto n = (LONG_PTR)h;
	char* ptr = str;
	char* head = str;

	if (n == 0) {
		*ptr++ = '0';
		*ptr = 0;
		return;
	}

	bool neg = n < 0;
	if (neg) n = -n;

	while (n) {
		*ptr++ = '0' + (n % 10);
		n /= 10;
	}
	if (neg) *ptr++ = '-';
	*ptr = 0;

	for (--ptr; head < ptr; ++head, --ptr) {
		char tmp = *head;
		*head = *ptr;
		*ptr = tmp;
	}
}
///
dllx const char* window_frame_get_wid() {
	static char buf[32];
	htoa10(frame_hwnd, buf);
	return buf;
}

dllx double window_get_topmost_raw() {
	return (GetWindowLong(active_hwnd, GWL_EXSTYLE) & WS_EX_TOPMOST) != 0;
}
dllx double window_set_topmost_raw(double stayontop) {
	//trace("topmost=%d", (int)stayontop);
	auto after = stayontop > 0.5 ? HWND_TOPMOST : HWND_NOTOPMOST;
	SetWindowPos(active_hwnd, after, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
	return true;
}

///
dllg double window_frame_set_background(int color) {
	WindowFrameCall(WindowFrameCall_t::SetBackgroundColor, color);
	return true;
}

///
dllx double window_is_maximized() {
	return IsZoomed(active_hwnd);
}

dllx double window_frame_redraw() {
	RedrawWindow(frame_hwnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE);
	return true;
}

dllx double window_frame_force_focus() {
	// this may sound odd, but the only way to *truly* focus a window appears to be
	// to simulate a click on it.
	//SetFocus(frame_hwnd);
	POINT oldPos;
	auto hasOldPos = GetCursorPos(&oldPos);
	RECT clientRect;
	GetClientRect(game_hwnd, &clientRect);
	POINT clientTL;
	clientTL.x = clientRect.left;
	clientTL.y = clientRect.top;
	ClientToScreen(game_hwnd, &clientTL);
	SetCursorPos(clientTL.x + 1, clientTL.y + 1);
	mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
	mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
	SetCursorPos(oldPos.x, oldPos.y);
	return true;
}/// window_frame_process.cpp
/// @author YellowAfterlife

#include "stdafx.h"
#include "window_frame.h"

static yal_set<WPARAM> blocked_syscommands;
static yal_set<WPARAM> hooked_syscommands;

static HWND hwnd;
static HWND get_game_hwnd() {
	auto hg = GetWindowFramePair(hwnd);
	if (!hg) return NULL;
	if (GetWindowFramePair(hg) != hwnd) {
		PostQuitMessage(0);
		return NULL;
	}
	return hg;
}
static DWORD wait_thread_id;
static HANDLE wait_thread_h;
static int min_width, min_height, max_width, max_height;
static HBRUSH background_brush;

static bool hook_syscommands;
LRESULT CALLBACK FrameWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
	trace_winmsg("frame", message, wParam, lParam);
	switch (message) {
		case WM_GETMINMAXINFO: {
			MINMAXINFO* mxi = (MINMAXINFO*)lParam;
			if (min_width >= 0) mxi->ptMinTrackSize.x = min_width;
			if (min_height >= 0) mxi->ptMinTrackSize.y = min_height;
			if (max_width >= 0) mxi->ptMaxTrackSize.x = max_width;
			if (max_height >= 0) mxi->ptMaxTrackSize.y = max_height;
			return 0;
		};
		case WM_DESTROY: {
			PostQuitMessage(0);
			return FALSE;
		};
		case WM_ERASEBKGND: {
			if (background_brush == nullptr) break;
			HDC hdc = (HDC)wParam;
			RECT cr; GetClientRect(hWnd, &cr);
			auto old_brush = SelectObject(hdc, background_brush);
			FillRect(hdc, &cr, background_brush);
			SelectObject(hdc, old_brush);
			return TRUE; // not needed here..?
		};
		case WM_KEYDOWN: case WM_KEYUP: case WM_SETCURSOR: case WM_MOUSEMOVE:
		case WM_HOTKEY: case WM_CHAR: case WM_MENUCHAR: case WM_INITMENUPOPUP:
		case WM_SYSCHAR: case WM_SYSDEADCHAR: case WM_SYSKEYDOWN: case WM_SYSKEYUP:
		case WM_DEVICECHANGE: {
			// forward device events to the game window:
			auto game = get_game_hwnd();
			if (game) SendMessage(game, message, wParam, lParam);
			break;
		};
		case WM_SETFOCUS: {
			// allegedly no side effects https://itch.io/post/537218
			auto game = get_game_hwnd();
			if (game) SetFocus(game);
			return 0;
		};
		case WM_SYSCOMMAND: {
			if (!hook_syscommands) break;
			if (wParam == SC_KEYMENU) break; // don't touch the system menu!
			auto cmd = wParam & ~15;
			if (blocked_syscommands.contains(cmd)) return TRUE;
			if (hooked_syscommands.contains(cmd)) {
				auto game = get_game_hwnd();
				if (game) SendMessage(game, WM_WF_SYSCOMMAND, wParam, lParam);
				return TRUE;
			}
			//MessageBoxA(0, "command", "me", MB_OK);
			break;
		};
		case WM_WF_SYSCOMMAND: {
			auto _hook = hook_syscommands;
			hook_syscommands = false;
			//DefWindowProc(hWnd, WM_SYSCOMMAND, wParam, lParam);
			auto result = SendMessage(hWnd, WM_SYSCOMMAND, wParam, lParam);
			hook_syscommands = _hook;
			return result;
		};
		case WM_WF_CALL: {
			switch ((WindowFrameCall_t)wParam) {
				case WindowFrameCall_t::DisableSysCommand: blocked_syscommands.add(lParam); break;
				case WindowFrameCall_t::EnableSysCommand: blocked_syscommands.remove(lParam); break;
				case WindowFrameCall_t::IsSysCommandEnabled: return !blocked_syscommands.contains(lParam);

				case WindowFrameCall_t::HookSysCommand: hooked_syscommands.add(lParam); break;
				case WindowFrameCall_t::UnhookSysCommand: hooked_syscommands.remove(lParam); break;
				case WindowFrameCall_t::IsSysCommandHooked: return hooked_syscommands.contains(lParam);

				case WindowFrameCall_t::SetBackgroundColor: {
					if (background_brush) DeleteObject(background_brush);
					if (lParam >= 0 && lParam <= 0xFFFFFF) {
						background_brush = CreateSolidBrush(RGB(
							(lParam & 0xff),
							(lParam >> 8) & 0xff,
							(lParam >> 16) & 0xff
						));
					} else background_brush = NULL;
					RedrawWindow(hWnd, NULL, NULL, RDW_ERASE|RDW_INVALIDATE);
				} break;

				case WindowFrameCall_t::SetMinWidth:  min_width = lParam; break;
				case WindowFrameCall_t::SetMinHeight: min_height = lParam; break;
				case WindowFrameCall_t::SetMaxWidth:  max_width = lParam; break;
				case WindowFrameCall_t::SetMaxHeight: max_height = lParam; break;

				//case WindowFrameCall_t::SetStdOut: trace_handle_set((HANDLE)lParam);
			}
			return TRUE;
		};
	}
	auto result = DefWindowProc(hWnd, message, wParam, lParam);
	return result;
}

static DWORD WINAPI wait_for_exit(void* _) {
	for (;;) {
		Sleep(100);
		auto game_hwnd = GetWindowFramePair(hwnd);
		if (game_hwnd && GetWindowFramePair(game_hwnd) != hwnd) {
			PostQuitMessage(0); // ExitProcess
		}
	}
}

static void init() {
	blocked_syscommands.init();
	hooked_syscommands.init();
	min_width = 80;
	min_height = 60;
	max_width = -1;
	max_height = -1;
	background_brush = NULL;
	hook_syscommands = true;
}

extern "C" __declspec(dllexport) void frame_process() {
	init();
	SetProcessDPIAware();
	//
	auto hInstance = GetModuleHandle(NULL);
	WNDCLASSEXW wcex;
	ZeroMemory(&wcex, sizeof wcex);
	wcex.cbSize = sizeof(WNDCLASSEX);
	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = FrameWndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = NULL;
	wcex.hCursor = NULL;
	wcex.hbrBackground = CreateSolidBrush(RGB(0, 0, 0));
	wcex.lpszMenuName = NULL;
	wcex.lpszClassName = L"window_frame";
	wcex.hIconSm = NULL;
	RegisterClassExW(&wcex);
	//
	hwnd = CreateWindowW(L"window_frame", L"(this is a helper program for window_frame.dll)",
		WS_OVERLAPPEDWINDOW | WS_CLIPCHILDREN, CW_USEDEFAULT, CW_USEDEFAULT, 400, 240,
		nullptr, nullptr, hInstance, nullptr);
	if (!hwnd) return;
	ShowWindow(hwnd, SW_HIDE);
	//
	wait_thread_h = CreateThread(NULL, 0, wait_for_exit, NULL, 0, &wait_thread_id);
	//
	MSG msg;
	while (GetMessage(&msg, nullptr, 0, 0)) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
}#include "window_frame.h"

bool window_frame_set_rect_impl(int x, int y, int w, int h, bool show) {
	HWND hwnd = active_hwnd;
	//
	RECT rect{};
	rect.left = x; rect.right = x + w;
	rect.top = y; rect.bottom = y + h;
	AdjustWindowRect(&rect, GetWindowLong(hwnd, GWL_STYLE), false);
	x = rect.left; w = rect.right - x;
	y = rect.top; h = rect.bottom - y;
	//
	if (show) {
		return SetWindowPos(hwnd, nullptr, x, y, w, h, SWP_SHOWWINDOW);
	} else return MoveWindow(hwnd, x, y, w, h, TRUE);
}

dllg bool window_frame_set_region(int x, int y, int width, int height) {
	if (frame_bound) {
		MoveWindow(game_hwnd, x, y, width, height, TRUE);
		return true;
	} else return false;
}

///
dllx double window_frame_get_width() {
	RECT rect = window_rect();
	auto w = rect.right - rect.left;
	return w;
}
///
dllx double window_frame_get_height() {
	RECT rect = window_rect();
	auto h = rect.bottom - rect.top;
	return h;
}
///
dllx double window_frame_get_x() {
	RECT rect = window_rect();
	return rect.left;
}
///
dllx double window_frame_get_y() {
	RECT rect = window_rect();
	return rect.top;
}

dllg tuple<int, int, int, int> window_frame_get_rect() {
	auto rect = window_rect();
	return tuple<int, int, int, int>(rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top);
}

dllg bool window_frame_set_rect(int x, int y, int width, int height) {
	return window_frame_set_rect_impl(x, y, width, height, false) != 0;
}

dllg bool window_frame_set_min_size(int minWidth, int minHeight) {
	WindowFrameCall(WindowFrameCall_t::SetMinWidth, minWidth);
	WindowFrameCall(WindowFrameCall_t::SetMinHeight, minHeight);
	return true;
}

dllg bool window_frame_set_max_size(int maxWidth, int maxHeight) {
	WindowFrameCall(WindowFrameCall_t::SetMaxWidth, maxWidth);
	WindowFrameCall(WindowFrameCall_t::SetMaxHeight, maxHeight);
	return true;
}